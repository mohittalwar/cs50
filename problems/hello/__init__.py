import check50

@check50.check()
def exists():
    """hello.py exists."""
    check50.exists("hello.py")

@check50.check(exists)
def veronica():
    """responds to name Ria."""
    check50.run("python3 hello.py").stdin("Ria").stdout("Ria").exit()

@check50.check(exists)
def brian():
    """responds to name Zubi."""
    check50.run("python3 hello.py").stdin("Zubi").stdout("Zubi").exit()
