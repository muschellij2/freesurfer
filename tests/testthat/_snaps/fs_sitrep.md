# fs_sitrep runs successfully

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

# alert_info correctly handles various scenarios

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

# alert_info provides expected warnings for default values

    Code
      alert_info(mock_fs_settings(value = "default_value", source = "Default",
        exists = TRUE), "Test Header")
    Message
      
      -- Test Header 
      * "default_value"
      ! Determined from: `Default`
      v Path exists

