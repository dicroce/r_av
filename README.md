# r_av

r_av is a C++ library that wraps some of the functionality of FFmpeg. There are enough classes here to do a full video transcode + recontainerization. If it doesn't do something you need I will always consider good PR's :)

A complete transcoding example involves reading frames from r_demuxer, decoding them with r_video_decoder, re-encoing them with r_encoder and finally writing them to a new file with r_muxer.

```
r_demuxer demuxer("true_north.mp4", true);
auto video_stream_index = demuxer.get_video_stream_index();
auto vsi = demuxer.get_stream_info(video_stream_index);

RTF_ASSERT(vsi.resolution.first == 640);
RTF_ASSERT(vsi.resolution.second == 360);

r_video_decoder decoder(vsi.codec_id);
decoder.set_extradata(demuxer.get_extradata(video_stream_index));
r_video_encoder encoder(AV_CODEC_ID_H264, 1000000, 320, 240, vsi.frame_rate, AV_PIX_FMT_YUV420P, 0, vsi.frame_rate.num, vsi.profile, vsi.level);

r_muxer muxer("truer_north.mp4");
muxer.add_video_stream(vsi.frame_rate, AV_CODEC_ID_H264, 320, 240, vsi.profile, vsi.level);
muxer.set_video_extradata(encoder.get_extradata());
muxer.open();

r_frame_info fi;

while(demuxer.read_frame())
{
    fi = demuxer.get_frame_info();

    if(fi.index == video_stream_index)
    {
        decoder.attach_buffer(fi.data, fi.size);

        auto decode_state = decoder.decode();

        if(decode_state == R_CODEC_STATE_AGAIN)
            continue;

        if(decode_state == R_CODEC_STATE_HAS_OUTPUT || decode_state == R_CODEC_STATE_AGAIN_HAS_OUTPUT)
        {
            auto frame = decoder.get(AV_PIX_FMT_YUV420P, 320, 240);

            int encode_attempts = 10;

ENCODE_AGAIN_TOP:
            --encode_attempts;
            encoder.attach_buffer(frame->data(), frame->size());

            auto encode_state = encoder.encode();

            if(encode_state == R_CODEC_STATE_AGAIN && encode_attempts > 0)
                goto ENCODE_AGAIN_TOP;

            if(encode_state == R_CODEC_STATE_HAS_OUTPUT)
            {
                auto pi = encoder.get();
                muxer.write_video_frame(pi.data, pi.size, pi.pts, pi.dts, pi.time_base, pi.key);
            }

            if(decode_state == R_CODEC_STATE_AGAIN_HAS_OUTPUT)
                continue;
        }
    }
}

auto decode_state = decoder.flush();
if(decode_state == R_CODEC_STATE_HAS_OUTPUT)
{
    auto frame = decoder.get(AV_PIX_FMT_YUV420P, 320, 240);

    int encode_attempts = 10;

ENCODE_AGAIN_BOTTOM:
    --encode_attempts;
    encoder.attach_buffer(frame->data(), frame->size());

    auto encode_state = encoder.encode();

    if(encode_state == R_CODEC_STATE_AGAIN && encode_attempts > 0)
        goto ENCODE_AGAIN_BOTTOM;

    if(encode_state == R_CODEC_STATE_HAS_OUTPUT)
    {
        auto pi = encoder.get();
        muxer.write_video_frame(pi.data, pi.size, pi.pts, pi.dts, pi.time_base, pi.key);
    }        
}

muxer.finalize();

```
