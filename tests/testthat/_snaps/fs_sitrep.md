# fs_sitrep: runs successfully

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
      * Install FreeSurfer license file in /mock/home, ENV_VAR, and TRUE

# fs_sitrep: alert_info correctly handles various scenarios

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

# fs_sitrep: alert_info provides expected warnings for default values

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * "default_value"
      ! Determined from: `Default`
      v Path exists

# fs_sitrep: returns early when FreeSurfer is not available

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

# fs_sitrep: handles unexpected mri_info output format

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

# fs_sitrep: handles failed mri_info command

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

# fs_sitrep: skips command testing when test_commands = FALSE

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

# fs_sitrep: recommends setting home when fs_home is NA

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

