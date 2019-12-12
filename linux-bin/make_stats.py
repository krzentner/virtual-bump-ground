import numpy as np
import pandas

vibration = pandas.read_csv('vibration.csv')

no_vibration = pandas.read_csv('no_vibration.csv')

vibration['dx'] = np.hstack(([0], (vibration['dx_total'][1:].array - vibration['dx_total'][:-1].array)))
vibration['dz'] = np.hstack(([0], (vibration['dz_total'][1:].array - vibration['dz_total'][:-1].array)))
no_vibration['dx'] = np.hstack(([0], (no_vibration['dx_total'][1:].array - no_vibration['dx_total'][:-1].array)))
no_vibration['dz'] = np.hstack(([0], (no_vibration['dz_total'][1:].array - no_vibration['dz_total'][:-1].array)))

vibration_dx_abs_sum = [np.abs(vibration[vibration['user_id'] == u]['dx']).sum() for u in range(8)]
no_vibration_dx_abs_sum = [np.abs(no_vibration[no_vibration['user_id'] == u]['dx']).sum() for u in range(8)]

vibration_dz_abs_sum = [np.abs(vibration[vibration['user_id'] == u]['dz']).sum() for u in range(8)]
no_vibration_dz_abs_sum = [np.abs(no_vibration[no_vibration['user_id'] == u]['dz']).sum() for u in range(8)]

print('vibration_dx_abs_sum', vibration_dx_abs_sum)
print('no_vibration_dx_abs_sum', no_vibration_dx_abs_sum)
print('vibration_dx_abs_sum_mean', np.mean(vibration_dx_abs_sum))
print('no_vibration_dx_abs_sum_mean', np.mean(no_vibration_dx_abs_sum))
print('vibration_dx_abs_sum_std', np.std(vibration_dx_abs_sum))
print('no_vibration_dx_abs_sum_std', np.std(no_vibration_dx_abs_sum))

print('vibration_dz_abs_sum', vibration_dz_abs_sum)
print('no_vibration_dz_abs_sum', no_vibration_dz_abs_sum)
print('vibration_dz_abs_sum_mean', np.mean(vibration_dz_abs_sum))
print('no_vibration_dz_abs_sum_mean', np.mean(no_vibration_dz_abs_sum))
print('vibration_dz_abs_sum_std', np.std(vibration_dz_abs_sum))
print('no_vibration_dz_abs_sum_std', np.std(no_vibration_dz_abs_sum))
