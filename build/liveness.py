import os
from telnetlib import Telnet
import logging
import subprocess


emulator_root = os.environ["ANDROID_HOME"] + '/emulator'
logging.basicConfig(level=logging.INFO)


def on_crash():
    logging.error('Emulator exiting')
    #TODO add some logs getters

    exit(1)


def check_by_telnet():
    f = open('/root/.emulator_console_auth_token')
    token = f.readline()
    f.close()
    logging.info('Auth token acquired')

    try:
        telnet = Telnet('127.0.0.1', 10000)
    except:
        logging.error('Error while connecting telnet')
        return on_crash()

    expectation = telnet.expect([b'OK'], timeout=0.5)
    if not expectation[1]:
        logging.error('Cant connect to emulator')
        return on_crash()
    logging.info('Connected to emulator')

    auth_line = ('auth ' + token + '\n').encode('ascii')
    telnet.write(auth_line)
    expectation = telnet.expect([b'OK'], timeout=0.5)
    if not expectation[1]:
        logging.error('Cant auth in emulator')
        return on_crash()
    logging.info('Authed in emulator')

    status_line = 'avd status\n'.encode('ascii')
    telnet.write(status_line)
    expectation = telnet.expect([b'virtual device is running'], timeout=0.5)
    if not expectation[1]:
        logging.error('Emulator is not running')
        return on_crash()
    logging.info('telnet is ok')


def check_by_adb():
    subprocess.Popen('adb shell getprop sys.boot_completed | grep -q "1"', shell=True).wait(10)
    logging.info('boot is ok')


check_by_telnet()
check_by_adb()
