from telnetlib import Telnet
import logging
import subprocess

logging.basicConfig(level=logging.INFO)


def check_by_telnet():
    f = open('/root/.emulator_console_auth_token')
    token = f.readline()
    f.close()
    logging.info('Auth token acquired')

    telnet = Telnet('127.0.0.1', 10000)
    expectation = telnet.expect([b'OK'], timeout=1)
    if not expectation[1]:
        logging.error('Cant connect to emulator')
        exit(1)
    logging.info('Connected to emulator')

    auth_line = ('auth ' + token + '\n').encode('ascii')
    telnet.write(auth_line)
    expectation = telnet.expect([b'OK'], timeout=1)
    if not expectation[1]:
        logging.error('Cant auth in emulator')
        exit(1)
    logging.info('Authed in emulator')

    status_line = 'avd status\n'.encode('ascii')
    telnet.write(status_line)
    expectation = telnet.expect([b'virtual device is running'], timeout=1)
    if not expectation[1]:
        logging.error('Emulator is not running')
        exit(1)
    logging.info('telnet is ok')


def check_by_adb():
    subprocess.Popen('adb shell getprop sys.boot_completed | grep -q "1"', shell=True).wait(10)
    logging.info('boot is ok')


def check_anr():
    pass


check_by_telnet()
check_by_adb()
