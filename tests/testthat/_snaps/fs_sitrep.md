# fs_sitrep() runs successfully [plain]

    Code
      fs_sitrep()
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * "/mock/home"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Source script 
      * "/mock/source.sh"
      ! Determined from: `Default`
      v Path exists
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * "/mock/subjects"
      i Determined from: `ENV_VAR`
      x Path does not exist
      
      -- Verbose mode 
      * "high"
      i Determined from: `Option`
      
      -- MNI functionality 
      * "/mock/mni/bin"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Output Format 
      * "nii"
      ! Determined from: `Default`
      v Path exists
      
      -- System Information 
      * Operating System: "mockOS 1.0"
      * R Version: "R 4.2.0"
      * Shell: "/bin/mocksh"
      
      -- Testing R and FreeSurfer Communication 
      * Version: "7.3.2"
      * Testing command execution with `mri_info --help`
      v R and FreeSurfer are working together
      * Command test successful
      
      -- Recommendations 
      * Install FreeSurfer license file in /mock/home

# fs_sitrep() runs successfully [ansi]

    Code
      fs_sitrep()
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * [34m"/mock/home"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Source script 
      * [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * [34m"/mock/subjects"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [31mx[39m Path does not exist
      
      -- Verbose mode 
      * [34m"high"[39m
      [36mi[39m Determined from: `Option`
      
      -- MNI functionality 
      * [34m"/mock/mni/bin"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Output Format 
      * [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- System Information 
      * Operating System: [34m"mockOS 1.0"[39m
      * R Version: [34m"R 4.2.0"[39m
      * Shell: [34m"/bin/mocksh"[39m
      
      -- Testing R and FreeSurfer Communication 
      * Version: [34m"7.3.2"[39m
      * Testing command execution with `mri_info --help`
      [32mv[39m R and FreeSurfer are working together
      * Command test successful
      
      -- Recommendations 
      * Install FreeSurfer license file in /mock/home

# fs_sitrep() runs successfully [unicode]

    Code
      fs_sitrep()
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • "/mock/home"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Source script 
      • "/mock/source.sh"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • "/mock/subjects"
      ℹ Determined from: `ENV_VAR`
      ✖ Path does not exist
      
      ── Verbose mode 
      • "high"
      ℹ Determined from: `Option`
      
      ── MNI functionality 
      • "/mock/mni/bin"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Output Format 
      • "nii"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── System Information 
      • Operating System: "mockOS 1.0"
      • R Version: "R 4.2.0"
      • Shell: "/bin/mocksh"
      
      ── Testing R and FreeSurfer Communication 
      • Version: "7.3.2"
      • Testing command execution with `mri_info --help`
      ✔ R and FreeSurfer are working together
      • Command test successful
      
      ── Recommendations 
      • Install FreeSurfer license file in /mock/home

# fs_sitrep() runs successfully [fancy]

    Code
      fs_sitrep()
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • [34m"/mock/home"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Source script 
      • [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • [34m"/mock/subjects"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [31m✖[39m Path does not exist
      
      ── Verbose mode 
      • [34m"high"[39m
      [36mℹ[39m Determined from: `Option`
      
      ── MNI functionality 
      • [34m"/mock/mni/bin"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Output Format 
      • [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── System Information 
      • Operating System: [34m"mockOS 1.0"[39m
      • R Version: [34m"R 4.2.0"[39m
      • Shell: [34m"/bin/mocksh"[39m
      
      ── Testing R and FreeSurfer Communication 
      • Version: [34m"7.3.2"[39m
      • Testing command execution with `mri_info --help`
      [32m✔[39m R and FreeSurfer are working together
      • Command test successful
      
      ── Recommendations 
      • Install FreeSurfer license file in /mock/home

# fs_sitrep()  alert_info correctly handles various scenarios [plain]

    Code
      alert_info(mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header")
    Message
      
      -- Test Header 
      * Unable to detect
    Output
      NULL

---

    Code
      alert_info(mock_fs_settings(value = c("/path1", "/path2"), source = "Default",
      exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      ! Multiple possible values found
      * "/path1"
      * "/path2"
      i Consider setting preferred value with `options`
      * "/path1"
      ! Determined from: `Default`
      v Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/valid/path", source = "Set via R Option",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * "/valid/path"
      i Determined from: `Set via R Option`
      v Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/invalid/path", source = "Set via R Option",
        exists = FALSE), "Path does not exist")
    Message
      
      -- Path does not exist 
      * "/invalid/path"
      i Determined from: `Set via R Option`
      x Path does not exist

---

    Code
      alert_info(mock_fs_settings(value = "/unknown/source", source = NA, exists = FALSE),
      "Test Header")
    Message
      
      -- Test Header 
      * "/unknown/source"
      x Path does not exist

# fs_sitrep()  alert_info correctly handles various scenarios [ansi]

    Code
      alert_info(mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header")
    Message
      
      -- Test Header 
      * Unable to detect
    Output
      NULL

---

    Code
      alert_info(mock_fs_settings(value = c("/path1", "/path2"), source = "Default",
      exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      [33m![39m Multiple possible values found
      * [34m"/path1"[39m
      * [34m"/path2"[39m
      [36mi[39m Consider setting preferred value with `options`
      * [34m"/path1"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/valid/path", source = "Set via R Option",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * [34m"/valid/path"[39m
      [36mi[39m Determined from: `Set via R Option`
      [32mv[39m Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/invalid/path", source = "Set via R Option",
        exists = FALSE), "Path does not exist")
    Message
      
      -- Path does not exist 
      * [34m"/invalid/path"[39m
      [36mi[39m Determined from: `Set via R Option`
      [31mx[39m Path does not exist

---

    Code
      alert_info(mock_fs_settings(value = "/unknown/source", source = NA, exists = FALSE),
      "Test Header")
    Message
      
      -- Test Header 
      * [34m"/unknown/source"[39m
      [31mx[39m Path does not exist

# fs_sitrep()  alert_info correctly handles various scenarios [unicode]

    Code
      alert_info(mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header")
    Message
      
      ── Test Header 
      • Unable to detect
    Output
      NULL

---

    Code
      alert_info(mock_fs_settings(value = c("/path1", "/path2"), source = "Default",
      exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      ! Multiple possible values found
      • "/path1"
      • "/path2"
      ℹ Consider setting preferred value with `options`
      • "/path1"
      ! Determined from: `Default`
      ✔ Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/valid/path", source = "Set via R Option",
        exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      • "/valid/path"
      ℹ Determined from: `Set via R Option`
      ✔ Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/invalid/path", source = "Set via R Option",
        exists = FALSE), "Path does not exist")
    Message
      
      ── Path does not exist 
      • "/invalid/path"
      ℹ Determined from: `Set via R Option`
      ✖ Path does not exist

---

    Code
      alert_info(mock_fs_settings(value = "/unknown/source", source = NA, exists = FALSE),
      "Test Header")
    Message
      
      ── Test Header 
      • "/unknown/source"
      ✖ Path does not exist

# fs_sitrep()  alert_info correctly handles various scenarios [fancy]

    Code
      alert_info(mock_fs_settings(value = NA, source = NA, exists = NA),
      "Test Header")
    Message
      
      ── Test Header 
      • Unable to detect
    Output
      NULL

---

    Code
      alert_info(mock_fs_settings(value = c("/path1", "/path2"), source = "Default",
      exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      [33m![39m Multiple possible values found
      • [34m"/path1"[39m
      • [34m"/path2"[39m
      [36mℹ[39m Consider setting preferred value with `options`
      • [34m"/path1"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/valid/path", source = "Set via R Option",
        exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      • [34m"/valid/path"[39m
      [36mℹ[39m Determined from: `Set via R Option`
      [32m✔[39m Path exists

---

    Code
      alert_info(mock_fs_settings(value = "/invalid/path", source = "Set via R Option",
        exists = FALSE), "Path does not exist")
    Message
      
      ── Path does not exist 
      • [34m"/invalid/path"[39m
      [36mℹ[39m Determined from: `Set via R Option`
      [31m✖[39m Path does not exist

---

    Code
      alert_info(mock_fs_settings(value = "/unknown/source", source = NA, exists = FALSE),
      "Test Header")
    Message
      
      ── Test Header 
      • [34m"/unknown/source"[39m
      [31m✖[39m Path does not exist

# fs_sitrep()  alert_info provides expected warnings for default values [plain]

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * "default_value"
      ! Determined from: `Default`
      v Path exists

# fs_sitrep()  alert_info provides expected warnings for default values [ansi]

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * [34m"default_value"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists

# fs_sitrep()  alert_info provides expected warnings for default values [unicode]

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      • "default_value"
      ! Determined from: `Default`
      ✔ Path exists

# fs_sitrep()  alert_info provides expected warnings for default values [fancy]

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      ── Test Header 
      • [34m"default_value"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists

# fs_sitrep()  returns early when FreeSurfer is not available [plain]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * Unable to detect
      
      -- Source script 
      * Unable to detect
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * Unable to detect
      
      -- Verbose mode 
      * FALSE
      
      -- MNI functionality 
      * Unable to detect
      
      -- Output Format 
      * Unable to detect
      
      -- System Information 
      * Operating System: "test"
      * R Version: "4.0.0"
      * Shell: "/bin/sh"
      
      -- Testing R and FreeSurfer Communication 
      x FreeSurfer installation not detected
      * Use `options(freesurfer.home = '/path/to/freesurfer')` to set location

# fs_sitrep()  returns early when FreeSurfer is not available [ansi]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * Unable to detect
      
      -- Source script 
      * Unable to detect
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * Unable to detect
      
      -- Verbose mode 
      * [34mFALSE[39m
      
      -- MNI functionality 
      * Unable to detect
      
      -- Output Format 
      * Unable to detect
      
      -- System Information 
      * Operating System: [34m"test"[39m
      * R Version: [34m"4.0.0"[39m
      * Shell: [34m"/bin/sh"[39m
      
      -- Testing R and FreeSurfer Communication 
      [31mx[39m FreeSurfer installation not detected
      * Use `options(freesurfer.home = '/path/to/freesurfer')` to set location

# fs_sitrep()  returns early when FreeSurfer is not available [unicode]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • Unable to detect
      
      ── Source script 
      • Unable to detect
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • Unable to detect
      
      ── Verbose mode 
      • FALSE
      
      ── MNI functionality 
      • Unable to detect
      
      ── Output Format 
      • Unable to detect
      
      ── System Information 
      • Operating System: "test"
      • R Version: "4.0.0"
      • Shell: "/bin/sh"
      
      ── Testing R and FreeSurfer Communication 
      ✖ FreeSurfer installation not detected
      • Use `options(freesurfer.home = '/path/to/freesurfer')` to set location

# fs_sitrep()  returns early when FreeSurfer is not available [fancy]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • Unable to detect
      
      ── Source script 
      • Unable to detect
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • Unable to detect
      
      ── Verbose mode 
      • [34mFALSE[39m
      
      ── MNI functionality 
      • Unable to detect
      
      ── Output Format 
      • Unable to detect
      
      ── System Information 
      • Operating System: [34m"test"[39m
      • R Version: [34m"4.0.0"[39m
      • Shell: [34m"/bin/sh"[39m
      
      ── Testing R and FreeSurfer Communication 
      [31m✖[39m FreeSurfer installation not detected
      • Use `options(freesurfer.home = '/path/to/freesurfer')` to set location

# fs_sitrep()  handles unexpected mri_info output format [plain]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * "/mock/home"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Source script 
      * "/mock/source.sh"
      ! Determined from: `Default`
      v Path exists
      
      -- License File 
      * "/mock/license.txt"
      i Determined from: `ENV`
      v Path exists
      
      -- Subjects Directory 
      * "/mock/subjects"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Verbose mode 
      * TRUE
      i Determined from: `Option`
      
      -- MNI functionality 
      * "/mock/mni/bin"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Output Format 
      * "nii"
      ! Determined from: `Default`
      v Path exists
      
      -- System Information 
      * Operating System: "test"
      * R Version: "4.0.0"
      * Shell: "/bin/sh"
      
      -- Testing R and FreeSurfer Communication 
      * Version: "7.3.2"
      * Testing command execution with `mri_info --help`
      ! FreeSurfer command executed but output format unexpected
      * Output preview: "Unexpected output that doesn't match pattern"
      
      -- Recommendations 
      v FreeSurfer setup looks good!

# fs_sitrep()  handles unexpected mri_info output format [ansi]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * [34m"/mock/home"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Source script 
      * [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- License File 
      * [34m"/mock/license.txt"[39m
      [36mi[39m Determined from: `ENV`
      [32mv[39m Path exists
      
      -- Subjects Directory 
      * [34m"/mock/subjects"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Verbose mode 
      * [34mTRUE[39m
      [36mi[39m Determined from: `Option`
      
      -- MNI functionality 
      * [34m"/mock/mni/bin"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Output Format 
      * [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- System Information 
      * Operating System: [34m"test"[39m
      * R Version: [34m"4.0.0"[39m
      * Shell: [34m"/bin/sh"[39m
      
      -- Testing R and FreeSurfer Communication 
      * Version: [34m"7.3.2"[39m
      * Testing command execution with `mri_info --help`
      [33m![39m FreeSurfer command executed but output format unexpected
      * Output preview: [34m"Unexpected output that doesn't match pattern"[39m
      
      -- Recommendations 
      [32mv[39m FreeSurfer setup looks good!

# fs_sitrep()  handles unexpected mri_info output format [unicode]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • "/mock/home"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Source script 
      • "/mock/source.sh"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── License File 
      • "/mock/license.txt"
      ℹ Determined from: `ENV`
      ✔ Path exists
      
      ── Subjects Directory 
      • "/mock/subjects"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Verbose mode 
      • TRUE
      ℹ Determined from: `Option`
      
      ── MNI functionality 
      • "/mock/mni/bin"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Output Format 
      • "nii"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── System Information 
      • Operating System: "test"
      • R Version: "4.0.0"
      • Shell: "/bin/sh"
      
      ── Testing R and FreeSurfer Communication 
      • Version: "7.3.2"
      • Testing command execution with `mri_info --help`
      ! FreeSurfer command executed but output format unexpected
      • Output preview: "Unexpected output that doesn't match pattern"
      
      ── Recommendations 
      ✔ FreeSurfer setup looks good!

# fs_sitrep()  handles unexpected mri_info output format [fancy]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • [34m"/mock/home"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Source script 
      • [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── License File 
      • [34m"/mock/license.txt"[39m
      [36mℹ[39m Determined from: `ENV`
      [32m✔[39m Path exists
      
      ── Subjects Directory 
      • [34m"/mock/subjects"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Verbose mode 
      • [34mTRUE[39m
      [36mℹ[39m Determined from: `Option`
      
      ── MNI functionality 
      • [34m"/mock/mni/bin"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Output Format 
      • [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── System Information 
      • Operating System: [34m"test"[39m
      • R Version: [34m"4.0.0"[39m
      • Shell: [34m"/bin/sh"[39m
      
      ── Testing R and FreeSurfer Communication 
      • Version: [34m"7.3.2"[39m
      • Testing command execution with `mri_info --help`
      [33m![39m FreeSurfer command executed but output format unexpected
      • Output preview: [34m"Unexpected output that doesn't match pattern"[39m
      
      ── Recommendations 
      [32m✔[39m FreeSurfer setup looks good!

# fs_sitrep()  handles failed mri_info command [plain]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * "/mock/home"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Source script 
      * "/mock/source.sh"
      ! Determined from: `Default`
      v Path exists
      
      -- License File 
      * "/mock/license.txt"
      i Determined from: `ENV`
      v Path exists
      
      -- Subjects Directory 
      * "/mock/subjects"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Verbose mode 
      * FALSE
      i Determined from: `Option`
      
      -- MNI functionality 
      * "/mock/mni/bin"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Output Format 
      * "nii"
      ! Determined from: `Default`
      v Path exists
      
      -- System Information 
      * Operating System: "test"
      * R Version: "4.0.0"
      * Shell: "/bin/sh"
      
      -- Testing R and FreeSurfer Communication 
      * Version: "7.3.2"
      * Testing command execution with `mri_info --help`
      x FreeSurfer and R are not working together
      * Command execution failed or returned no output
      
      -- Recommendations 
      * Enable verbose mode for better debugging: `options(freesurfer.verbose =
      TRUE)`

# fs_sitrep()  handles failed mri_info command [ansi]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * [34m"/mock/home"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Source script 
      * [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- License File 
      * [34m"/mock/license.txt"[39m
      [36mi[39m Determined from: `ENV`
      [32mv[39m Path exists
      
      -- Subjects Directory 
      * [34m"/mock/subjects"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Verbose mode 
      * [34mFALSE[39m
      [36mi[39m Determined from: `Option`
      
      -- MNI functionality 
      * [34m"/mock/mni/bin"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Output Format 
      * [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- System Information 
      * Operating System: [34m"test"[39m
      * R Version: [34m"4.0.0"[39m
      * Shell: [34m"/bin/sh"[39m
      
      -- Testing R and FreeSurfer Communication 
      * Version: [34m"7.3.2"[39m
      * Testing command execution with `mri_info --help`
      [31mx[39m FreeSurfer and R are not working together
      * Command execution failed or returned no output
      
      -- Recommendations 
      * Enable verbose mode for better debugging: `options(freesurfer.verbose =
      TRUE)`

# fs_sitrep()  handles failed mri_info command [unicode]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • "/mock/home"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Source script 
      • "/mock/source.sh"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── License File 
      • "/mock/license.txt"
      ℹ Determined from: `ENV`
      ✔ Path exists
      
      ── Subjects Directory 
      • "/mock/subjects"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Verbose mode 
      • FALSE
      ℹ Determined from: `Option`
      
      ── MNI functionality 
      • "/mock/mni/bin"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Output Format 
      • "nii"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── System Information 
      • Operating System: "test"
      • R Version: "4.0.0"
      • Shell: "/bin/sh"
      
      ── Testing R and FreeSurfer Communication 
      • Version: "7.3.2"
      • Testing command execution with `mri_info --help`
      ✖ FreeSurfer and R are not working together
      • Command execution failed or returned no output
      
      ── Recommendations 
      • Enable verbose mode for better debugging: `options(freesurfer.verbose =
      TRUE)`

# fs_sitrep()  handles failed mri_info command [fancy]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • [34m"/mock/home"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Source script 
      • [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── License File 
      • [34m"/mock/license.txt"[39m
      [36mℹ[39m Determined from: `ENV`
      [32m✔[39m Path exists
      
      ── Subjects Directory 
      • [34m"/mock/subjects"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Verbose mode 
      • [34mFALSE[39m
      [36mℹ[39m Determined from: `Option`
      
      ── MNI functionality 
      • [34m"/mock/mni/bin"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Output Format 
      • [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── System Information 
      • Operating System: [34m"test"[39m
      • R Version: [34m"4.0.0"[39m
      • Shell: [34m"/bin/sh"[39m
      
      ── Testing R and FreeSurfer Communication 
      • Version: [34m"7.3.2"[39m
      • Testing command execution with `mri_info --help`
      [31m✖[39m FreeSurfer and R are not working together
      • Command execution failed or returned no output
      
      ── Recommendations 
      • Enable verbose mode for better debugging: `options(freesurfer.verbose =
      TRUE)`

# fs_sitrep()  skips command testing when test_commands = FALSE [plain]

    Code
      fs_sitrep(test_commands = FALSE)
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * "/mock/home"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Source script 
      * "/mock/source.sh"
      ! Determined from: `Default`
      v Path exists
      
      -- License File 
      * "/mock/license.txt"
      i Determined from: `ENV`
      v Path exists
      
      -- Subjects Directory 
      * "/mock/subjects"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Verbose mode 
      * TRUE
      i Determined from: `Option`
      
      -- MNI functionality 
      * "/mock/mni/bin"
      i Determined from: `ENV_VAR`
      v Path exists
      
      -- Output Format 
      * "nii"
      ! Determined from: `Default`
      v Path exists
      
      -- System Information 
      * Operating System: "test"
      * R Version: "4.0.0"
      * Shell: "/bin/sh"
      
      -- Recommendations 
      v FreeSurfer setup looks good!

# fs_sitrep()  skips command testing when test_commands = FALSE [ansi]

    Code
      fs_sitrep(test_commands = FALSE)
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * [34m"/mock/home"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Source script 
      * [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- License File 
      * [34m"/mock/license.txt"[39m
      [36mi[39m Determined from: `ENV`
      [32mv[39m Path exists
      
      -- Subjects Directory 
      * [34m"/mock/subjects"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Verbose mode 
      * [34mTRUE[39m
      [36mi[39m Determined from: `Option`
      
      -- MNI functionality 
      * [34m"/mock/mni/bin"[39m
      [36mi[39m Determined from: `ENV_VAR`
      [32mv[39m Path exists
      
      -- Output Format 
      * [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32mv[39m Path exists
      
      -- System Information 
      * Operating System: [34m"test"[39m
      * R Version: [34m"4.0.0"[39m
      * Shell: [34m"/bin/sh"[39m
      
      -- Recommendations 
      [32mv[39m FreeSurfer setup looks good!

# fs_sitrep()  skips command testing when test_commands = FALSE [unicode]

    Code
      fs_sitrep(test_commands = FALSE)
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • "/mock/home"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Source script 
      • "/mock/source.sh"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── License File 
      • "/mock/license.txt"
      ℹ Determined from: `ENV`
      ✔ Path exists
      
      ── Subjects Directory 
      • "/mock/subjects"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Verbose mode 
      • TRUE
      ℹ Determined from: `Option`
      
      ── MNI functionality 
      • "/mock/mni/bin"
      ℹ Determined from: `ENV_VAR`
      ✔ Path exists
      
      ── Output Format 
      • "nii"
      ! Determined from: `Default`
      ✔ Path exists
      
      ── System Information 
      • Operating System: "test"
      • R Version: "4.0.0"
      • Shell: "/bin/sh"
      
      ── Recommendations 
      ✔ FreeSurfer setup looks good!

# fs_sitrep()  skips command testing when test_commands = FALSE [fancy]

    Code
      fs_sitrep(test_commands = FALSE)
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • [34m"/mock/home"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Source script 
      • [34m"/mock/source.sh"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── License File 
      • [34m"/mock/license.txt"[39m
      [36mℹ[39m Determined from: `ENV`
      [32m✔[39m Path exists
      
      ── Subjects Directory 
      • [34m"/mock/subjects"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Verbose mode 
      • [34mTRUE[39m
      [36mℹ[39m Determined from: `Option`
      
      ── MNI functionality 
      • [34m"/mock/mni/bin"[39m
      [36mℹ[39m Determined from: `ENV_VAR`
      [32m✔[39m Path exists
      
      ── Output Format 
      • [34m"nii"[39m
      [33m![39m Determined from: `Default`
      [32m✔[39m Path exists
      
      ── System Information 
      • Operating System: [34m"test"[39m
      • R Version: [34m"4.0.0"[39m
      • Shell: [34m"/bin/sh"[39m
      
      ── Recommendations 
      [32m✔[39m FreeSurfer setup looks good!

# fs_sitrep()  recommends setting home when fs_home is NA [plain]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- FreeSurfer Setup Report --
      
      -- FreeSurfer Directory 
      * Unable to detect
      
      -- Source script 
      * Unable to detect
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * Unable to detect
      
      -- Verbose mode 
      * FALSE
      
      -- MNI functionality 
      * Unable to detect
      
      -- Output Format 
      * Unable to detect
      
      -- System Information 
      * Operating System: "test"
      * R Version: "4.0.0"
      * Shell: "/bin/sh"
      
      -- Testing R and FreeSurfer Communication 
      * Version: "7.0.0"
      * Testing command execution with `mri_info --help`
      v R and FreeSurfer are working together
      * Command test successful
      
      -- Recommendations 
      * Set FreeSurfer home: `options(freesurfer.home = '/path/to/freesurfer')`

# fs_sitrep()  recommends setting home when fs_home is NA [ansi]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      -- [1m[1mFreeSurfer Setup Report[1m[22m --
      
      -- FreeSurfer Directory 
      * Unable to detect
      
      -- Source script 
      * Unable to detect
      
      -- License File 
      * Unable to detect
      
      -- Subjects Directory 
      * Unable to detect
      
      -- Verbose mode 
      * [34mFALSE[39m
      
      -- MNI functionality 
      * Unable to detect
      
      -- Output Format 
      * Unable to detect
      
      -- System Information 
      * Operating System: [34m"test"[39m
      * R Version: [34m"4.0.0"[39m
      * Shell: [34m"/bin/sh"[39m
      
      -- Testing R and FreeSurfer Communication 
      * Version: [34m"7.0.0"[39m
      * Testing command execution with `mri_info --help`
      [32mv[39m R and FreeSurfer are working together
      * Command test successful
      
      -- Recommendations 
      * Set FreeSurfer home: `options(freesurfer.home = '/path/to/freesurfer')`

# fs_sitrep()  recommends setting home when fs_home is NA [unicode]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── FreeSurfer Setup Report ──
      
      ── FreeSurfer Directory 
      • Unable to detect
      
      ── Source script 
      • Unable to detect
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • Unable to detect
      
      ── Verbose mode 
      • FALSE
      
      ── MNI functionality 
      • Unable to detect
      
      ── Output Format 
      • Unable to detect
      
      ── System Information 
      • Operating System: "test"
      • R Version: "4.0.0"
      • Shell: "/bin/sh"
      
      ── Testing R and FreeSurfer Communication 
      • Version: "7.0.0"
      • Testing command execution with `mri_info --help`
      ✔ R and FreeSurfer are working together
      • Command test successful
      
      ── Recommendations 
      • Set FreeSurfer home: `options(freesurfer.home = '/path/to/freesurfer')`

# fs_sitrep()  recommends setting home when fs_home is NA [fancy]

    Code
      fs_sitrep(test_commands = TRUE)
    Message
      
      ── [1m[1mFreeSurfer Setup Report[1m[22m ──
      
      ── FreeSurfer Directory 
      • Unable to detect
      
      ── Source script 
      • Unable to detect
      
      ── License File 
      • Unable to detect
      
      ── Subjects Directory 
      • Unable to detect
      
      ── Verbose mode 
      • [34mFALSE[39m
      
      ── MNI functionality 
      • Unable to detect
      
      ── Output Format 
      • Unable to detect
      
      ── System Information 
      • Operating System: [34m"test"[39m
      • R Version: [34m"4.0.0"[39m
      • Shell: [34m"/bin/sh"[39m
      
      ── Testing R and FreeSurfer Communication 
      • Version: [34m"7.0.0"[39m
      • Testing command execution with `mri_info --help`
      [32m✔[39m R and FreeSurfer are working together
      • Command test successful
      
      ── Recommendations 
      • Set FreeSurfer home: `options(freesurfer.home = '/path/to/freesurfer')`

