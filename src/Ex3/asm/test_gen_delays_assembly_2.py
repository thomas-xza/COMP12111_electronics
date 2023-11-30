import unittest

from gen_delays_assembly import *

class Test_gen_assembly(unittest.TestCase):

    
    def test_get_next_m_light_1(self):

        next_light = get_next_m_light(0xffa)

        print(hex(next_light))

        self.assertEqual(next_light, 0xff9)


    def test_get_next_m_light_2(self):

        next_light = get_next_m_light(0xff8)

        print(hex(next_light))

        self.assertEqual(next_light, 0xff7)


if __name__ == '__main__':
    unittest.main()
