"""The personal and work Claude settings must differ only in an allowlist of keys.

Duplication is acceptable only when something enforces the invariant. This repo has
already seen the failure mode: agents/shared/skills/ was duplicated with the intent
of staying in sync and drifted three ways before anyone noticed.
"""

import json
import pathlib

import pytest

REPO = pathlib.Path(__file__).resolve().parent.parent
PERSONAL = REPO / "agents" / "claude" / "settings.personal.json"
WORK = REPO / "agents" / "claude" / "settings.work.json"

# The only keys allowed to differ between the two profiles.
ALLOWED_TO_DIFFER = {
    "enabledPlugins",
    "extraKnownMarketplaces",
    "pluginConfigs",
}


@pytest.fixture(scope="module")
def settings():
    return json.loads(PERSONAL.read_text()), json.loads(WORK.read_text())


def test_both_files_exist():
    assert PERSONAL.is_file(), f"missing {PERSONAL}"
    assert WORK.is_file(), f"missing {WORK}"


def test_only_allowlisted_keys_differ(settings):
    personal, work = settings
    differing = {k for k in set(personal) | set(work) if personal.get(k) != work.get(k)}
    unexpected = differing - ALLOWED_TO_DIFFER
    assert not unexpected, (
        f"settings.personal.json and settings.work.json differ in {sorted(unexpected)}, "
        "which is not allowlisted. Add the setting to both files, or add the key to "
        "ALLOWED_TO_DIFFER if it is genuinely profile-specific."
    )


def test_work_is_a_superset_of_personal_plugins(settings):
    personal, work = settings
    missing = set(personal["enabledPlugins"]) - set(work["enabledPlugins"])
    assert not missing, f"work profile is missing personal plugins: {sorted(missing)}"


def test_personal_has_no_work_plugins(settings):
    personal, _ = settings
    leaked = [k for k in personal["enabledPlugins"] if "octant" in k or "databricks" in k]
    assert not leaked, (
        f"work plugins leaked into the personal profile: {leaked}. "
        "This is the defect that fired OCTOMIND hooks into personal sessions."
    )


def test_every_enabled_plugin_has_a_known_marketplace(settings):
    for name, data in zip(("personal", "work"), settings):
        marketplaces = set(data.get("extraKnownMarketplaces", {}))
        for plugin in data["enabledPlugins"]:
            _, _, marketplace = plugin.partition("@")
            assert marketplace in marketplaces, (
                f"{name}: plugin {plugin!r} references marketplace {marketplace!r} "
                "which is not in extraKnownMarketplaces"
            )
