REM use admin cmd prompt
REM creates on C:, store more securely afterwards

manage-bde -protectors -add c: -recoverykey c:
attrib -h -s c:\*.bek