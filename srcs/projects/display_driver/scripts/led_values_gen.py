led_values = []

# FIRST QUAD
led_row =  0*[0b0] + 8*[0b100000] + 24*[0b0]
led_values.append(led_row)
led_row =  8*[0b0] + 8*[0b100000] + 16*[0b0]
led_values.append(led_row)
led_row = 16*[0b0] + 8*[0b100000] +  8*[0b0]
led_values.append(led_row)
led_row = 24*[0b0] + 8*[0b100000] +  0*[0b0]
led_values.append(led_row)

# SECOND QUAD
led_row =  0*[0b0] + 8*[0b001000] + 24*[0b0]
led_values.append(led_row)
led_row =  8*[0b0] + 8*[0b001000] + 16*[0b0]
led_values.append(led_row)
led_row = 16*[0b0] + 8*[0b001000] +  8*[0b0]
led_values.append(led_row)
led_row = 24*[0b0] + 8*[0b001000] +  0*[0b0]
led_values.append(led_row)

# THIRD QUAD
led_row =  0*[0b0] + 8*[0b000001] + 24*[0b0]
led_values.append(led_row)
led_row =  8*[0b0] + 8*[0b000001] + 16*[0b0]
led_values.append(led_row)
led_row = 16*[0b0] + 8*[0b000001] +  8*[0b0]
led_values.append(led_row)
led_row = 24*[0b0] + 8*[0b000001] +  0*[0b0]
led_values.append(led_row)

# FOURTH QUAD
led_row =  0*[0b0] + 8*[0b010101] + 24*[0b0]
led_values.append(led_row)
led_row =  8*[0b0] + 8*[0b010101] + 16*[0b0]
led_values.append(led_row)
led_row = 16*[0b0] + 8*[0b010101] +  8*[0b0]
led_values.append(led_row)
led_row = 24*[0b0] + 8*[0b010101] +  0*[0b0]
led_values.append(led_row)

print("\n".join([ ", ".join([f"0x{x:02x}" for x in li]) for li in led_values ]))