local ffmpeg = require('ffmpeg.torch')

describe('ffmpeg.torch', function()
  describe('Video', function()
    local video
    local n_video_frames = 418

    before_each(function()
      video = ffmpeg.new('./test/data/centaur_1.mpg')
    end)

    describe(':to_byte_tensor', function()
      it('should convert greyscale frame into a 1-channel byte tensor', function()
        -- 3x3 pixel greyscale version of first frame
        local expected = {{
          {0, 1, 0},
          {0, 24, 1},
          {0, 18, 0}
        }}

        local actual = video
          :filter('gray', 'scale=3:3')
          :read_video_frame()
          :to_byte_tensor()
          :totable()

        assert.are.same(expected, actual)
      end)

      it('should convert RGB frame into a 3-channel byte tensor', function()
        local actual_tensor = video
          :filter('rgb24', 'scale=16:16')
          :read_video_frame()
          :to_byte_tensor()

        assert.are.same(actual_tensor:size():totable(), {3, 16, 16})
      end)
    end)
  end)
end)
