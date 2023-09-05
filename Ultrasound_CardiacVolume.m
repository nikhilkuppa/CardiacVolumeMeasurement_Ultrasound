ch4 = VideoReader('Apical4ch.mp4');
apex = VideoReader('ShortAxis_Apex.mp4');
mitral = VideoReader('ShortAxis_MitralValve.mp4');
pap = VideoReader('ShortAxis_Pap.mp4');

[sv, edv, esv, ef, co]=stroke_volume(ch4,apex,mitral,pap);

disp(['End-Diastolic Volume: ' num2str(edv)]);
disp(['End-Systolic Volume: ' num2str(esv)]);
disp(['Stroke Volume: ' num2str(sv)]);
disp(['Ejection Fraction: '  num2str(ef)])
disp(['Cardiac Output: ' num2str(co)])

function [sv, edv, esv, ef, co]=stroke_volume(ch4,apex,mitral,pap) 

    video_watch(ch4);
    [Lendo_dia, Lendo_sys] = axis_length(ch4);
    h_dia = Lendo_dia/3;
    h_sys = Lendo_sys/3;
    
    video_watch(mitral);
    [mitral_dia, mitral_sys] = axis_length(mitral);
    A1_dia = pi*((mitral_dia/2)^2);
    A1_sys = pi*((mitral_sys/2)^2);
    
    video_watch(pap);
    [pap_dia, pap_sys] = axis_length(pap);
    A2_dia = pi*((pap_dia/2)^2);
    A2_sys = pi*((pap_sys/2)^2);
    
    video_watch(apex);
    [apex_dia, apex_sys] = axis_length(apex);
    A3_dia = pi*((apex_dia/2)^2);
    A3_sys = pi*((apex_sys/2)^2);
    
    edv = (A1_dia + A2_dia)*h_dia + (A3_dia*h_dia/2) + (pi*(h_dia^3)/6);
    esv = (A1_sys + A2_sys)*h_sys + (A3_sys*h_sys/2) + (pi*(h_sys^3)/6);
    sv = edv-esv;
    ef = sv/edv;
    hr = 80;
    co = sv*hr;

end

function video_watch(vid)
    fprintf('\nWatch the video and note the frame number of End-Diastole and End-Systole\n')
    for count = 1:3:vid.NumFrames
       vidFrame = read(vid, count);
       imshow(vidFrame)
       title(sprintf('Frame Number: %.1f', count));
       pause(1)
    end
end

function [ed_dist, es_dist]=axis_length(vid)
    
    ed_framenum = input('Enter End Diastole Frame Number:'); %35
    ed_frame = read(vid, ed_framenum);
    imagesc(ed_frame)
    title('Click once on the endpoints of distance you want to measure')
    [x, y] = ginput(2);
    ed_dist = (sqrt((x(2)-x(1))^2 + (y(2)-y(1))^2))/33;
    disp(['ED dist:' num2str((ed_dist))])

    es_framenum = input('Enter End Systole Frame Number:'); %50
    es_frame = read(vid, es_framenum);
    imagesc(es_frame)
    title('Click once on the endpoints of distance you want to measure')
    [x, y] = ginput(2);
    es_dist = (sqrt((x(2)-x(1))^2 + (y(2)-y(1))^2))/33;
    disp(['ES dist:' num2str((es_dist))])

end