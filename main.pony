use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestNotifier)

class iso _TestNotifier is UnitTest
  fun name(): String => "test notifier"

  fun apply(h: TestHelper) =>
    let r = Receiver(recover TestNotifier(h, "Hi") end)

    r.receive("Hi")
    h.long_test(2_000_000_000)

  fun timed_out(h: TestHelper) =>
    h.complete(false)

class TestNotifier is Notified
  let _h: TestHelper
  let _expected: String

  new iso create(h: TestHelper, expected: String) =>
    _h = h
    _expected = expected

  fun ref received(rec: Receiver ref, msg: String) =>
   _h.assert_eq[String](_expected, msg)
   _h.complete(true)

interface Notified
  fun ref received(rec: Receiver ref, msg: String)

actor Receiver
  let _notify: Notified

  new create(notify: Notified iso) =>
    _notify = consume notify

  be receive(msg: String) =>
    _notify.received(this, msg)
