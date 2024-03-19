import logging
import os
import subprocess

emulator_root = os.environ["ANDROID_HOME"] + '/emulator'
logging.basicConfig(level=logging.INFO)


def on_crash():
    logging.error('Emulator exiting')
    # TODO add some logs getters
    subprocess.run(emulator_root + '/crashreport -u', shell=True, stdout=open('/opt/crashreport.txt', 'wb'))
    log_file = open('/opt/crashreport.txt')
    log_file_content = log_file.read()
    logging.info(log_file_content)

    exit(1)


if __name__ == '__main__':
    on_crash()
