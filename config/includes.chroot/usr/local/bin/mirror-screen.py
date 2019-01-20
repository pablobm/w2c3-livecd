import re
import subprocess

class DisplayInfo:
    def __init__(self, displays):
        self.displays = displays

    @property
    def primary(self):
        return next(d for d in self.displays if d.is_primary)

    @property
    def secondaries(self):
        return [d for d in self.displays if not d.is_primary]


class Display:
    def __init__(self):
        self.name = None
        self.is_primary = False
        self.modes = []

    @property
    def max_mode(self):
        best = None
        max_prod = 0
        for m in self.modes:
            if max_prod < m.w * m.h:
                best = m
                max_prod = m.w * m.h
        return best


class Mode:
    def __init__(self, w, h):
        self.w = w
        self.h = h

    def correction_for(self, other):
        return CorrectionFactor(self.w / other.w, self.h / other.h)

    def __str__(self):
        return '%sx%s' % (self.w, self.h)


class CorrectionFactor:
    def __init__(self, x, y):
        self.x = x
        self.y = y

    def __str__(self):
        return '%sx%s' % (self.x, self.y)

def run(line):
    print(line)
    subprocess.run(line.split(" "))

displays = []
result = subprocess.run(['xrandr'], capture_output=True)
for line in result.stdout.decode('utf8').splitlines():
    m = re.search(r'^(\S+) connected (primary)?', line)
    if m:
        display = Display()
        display.name = m[1]
        display.is_primary = bool(m[2])
        displays.append(display)
    else:
        m = re.search(r'^\s+(\d+)x(\d+) ', line)
        if m:
            mode = Mode(int(m[1]), int(m[2]))
            display.modes.append(mode)

dinfo = DisplayInfo(displays)
primary = dinfo.primary
pmode = primary.max_mode

run('xrandr --output %s --mode %s --pos 0x0' % (primary.name, pmode))
for d in dinfo.secondaries:
    smode = d.max_mode
    correction = pmode.correction_for(smode)
    print(correction)
    run('xrandr --output %s --pos 0x0 --mode %s --scale %s' % (d.name, smode, correction))
