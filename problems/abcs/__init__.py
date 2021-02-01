import check50

@check50.check()
def exists():
    """abcs.py exists."""
    check50.exists("abcs.py")

@check50.check(exists)
def sample():
    """sample input returns sample output."""
    check50.run("python3 abcs.py").stdin("2 2 11 4 9 7 9").stdout("2 2 7").exit()

@check50.check(exists)
def test000():
    """passes for [0, 0, 0]."""
    check50.run("python3 abcs.py").stdin("0 0 0 0 0 0 0").stdout("0 0 0").exit()

@check50.check(exists)
def test001():
    """passes for [0, 0, 1]."""
    check50.run("python3 abcs.py").stdin("0 0 1 1 1 0 1").stdout("0 0 1").exit()

@check50.check(exists)
def test012():
    """passes for [0, 1, 2]."""
    check50.run("python3 abcs.py").stdin("2 1 2 0 3 3 1").stdout("0 1 2").exit()

@check50.check(exists)
def test111():
    """passes for [1, 1, 1]."""
    check50.run("python3 abcs.py").stdin("3 2 1 2 1 1 2").stdout("1 1 1").exit()

@check50.check(exists)
def test112():
    """passes for [1, 1, 2]."""
    check50.run("python3 abcs.py").stdin("2 1 3 1 4 3 2").stdout("1 1 2").exit()

@check50.check(exists)
def test123():
    """passes for [1, 2, 3]."""
    check50.run("python3 abcs.py").stdin("1 4 6 2 3 5 3").stdout("1 2 3").exit()

@check50.check(exists)
def testLarge():
    """passes for large numbers."""
    check50.run("python3 abcs.py").stdin("1000002 1000001 2000001 2000003 3000003 2000002 1000000").stdout("1000000 1000001 1000002").exit()
