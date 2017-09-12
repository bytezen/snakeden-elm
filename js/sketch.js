function setup() {
    let canvas = createCanvas(640,480);
    canvas.parent('appContainer')
    noLoop();
}

function draw() {
    background(200);
    rect(50,50,300,300);
}