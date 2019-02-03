#!/usr/bin/env python
import re
import subprocess

class DisplayInfo:
    def __init__(self, displays):
        self.displays = displays

    @property
    def primary(self):
        try:
            return next(d for d in self.displays if d.is_primary)
        except StopIteration:
            # No screeen marked as primary
            None

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
        print self
        print other
        return CorrectionFactor(float(self.w) / other.w, float(self.h) / other.h)

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
    proc = subprocess.Popen(line.split(" "), stdout=subprocess.PIPE)
    return proc.communicate()[0]

displays = []
result = run('xrandr')
for line in result.decode('utf8').splitlines():
    m = re.search(r'^(\S+) connected (primary)?', line)
    if m:
        display = Display()
        display.name = m.group(1)
        display.is_primary = bool(m.group(2))
        displays.append(display)
    else:
        m = re.search(r'^\s+(\d+)x(\d+) ', line)
        if m:
            mode = Mode(int(m.group(1)), int(m.group(2)))
            display.modes.append(mode)

dinfo = DisplayInfo(displays)
primary = dinfo.primary
if not primary:
    try:
        heuristic_primary = next(d for d in dinfo.displays if d.name == 'LVDS1')
    except StopIteration:
        raise Exception
    primary = heuristic_primary
    primary.is_primary = True

pmode = primary.max_mode

run('xrandr --output %s --mode %s --pos 0x0' % (primary.name, pmode))
for d in dinfo.secondaries:
    smode = d.max_mode
    correction = pmode.correction_for(smode)
    run('xrandr --output %s --pos 0x0 --mode %s --scale %s' % (d.name, smode, correction))
