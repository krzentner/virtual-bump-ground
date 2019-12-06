#!/usr/bin/env python3
import os
import csv
import pdb

vibration = []
no_vibration = []

keys = ['dt_total', 'x_offset', 'z_offset', 'angle_offset', 'dx_total',
        'dz_total']


def get_table(lines):
    table = {k: [] for k in keys}
    for line in lines:
        for key in keys:
            if key in line:
                try:
                    key, value = line.split('\t')
                    value = float(value)
                    table[key].append(value)
                except ValueError:
                    pass
    return table


for user_n in range(1, 9):
    print('user_n', user_n)
    with open('user{}_vibration.log'.format(user_n)) as f:
        vibration.append(get_table(f))
    with open('user{}_no_vibration.log'.format(user_n)) as f:
        no_vibration.append(get_table(f))


def write_csv(table, filename):
    with open(filename, 'w') as f:
        writer = csv.writer(f)
        writer.writerow(keys + ['user_id'])
        for user_id, user in enumerate(table):
            for i in range(len(user['dz_total'])):
                writer.writerow([user[key][i] for key in keys] + [user_id])


write_csv(vibration, 'vibration.csv')
write_csv(no_vibration, 'no_vibration.csv')
