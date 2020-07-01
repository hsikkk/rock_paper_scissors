n= 100;

for k = 1:n
    img = snapshot(cam);
    
    imwrite(img,sprintf('rock_paper_scissors\\paper\\image_%04d.jpg',k), 'jpeg');
    pause(0.5);
    
end