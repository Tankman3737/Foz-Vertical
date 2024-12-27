# Basic Layout For Attract Mode Plus
# Design By: Tankman
# Coded By: Tankman



# Layout Size

fe.layout.width=1080;
fe.layout.height=1920;
fe.layout.preserve_aspect_ratio = true

# Modules

fe.load_module("inertia");

fe.load_module( "animate" );
fe.do_nut ( "artwork/harrier.nut" );

local t = fe.add_image( "artwork/BG1.png", 0, 0, 1080, 1920);



local surfacewheel = fe.add_surface(1080, 1920);
surfacewheel.set_pos( 0,0)
surfacewheel.mipmap = true
local MG = surfacewheel.add_image( "artwork/MG.png", 0, 0, 1080, 1920);


				local an = { when=Transition.ToNewSelection, property="alpha", start=255, end=0,delay =1500,time=1000 }
animation.add( PropertyAnimation( MG, an ) );
  local an2 = { when=Transition.FromOldSelection, property="alpha", start=255, end=255,time=1 }
animation.add( PropertyAnimation( MG, an2 ) );

				//local an = { when=Transition.ToNewSelection, property="alpha", start=255, end=0,delay =2000,time=1000 }
//animation.add( PropertyAnimation( t, an ) );
  //local an2 = { when=Transition.FromOldSelection, property="alpha", start=255, end=255,time=1 }
//animation.add( PropertyAnimation( t, an2 ) );




local harrier = harrier( 270, 0, 550,1920, 5, 1, 0, 0, 0 )
harrier.surfacePosSmoothing = 0.95
harrier.set_keep_aspect()







# Date & Time 

function update_clock(ttime)
{
    now <- date();
    
    if (now.hour == 0) {
        now.hour = 12;
        dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min) + " AM";
    } else if (now.hour < 12) {
        dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min) + " AM";
    } else if (now.hour == 12) {
        dt.msg = format("%02d", now.hour) + ":" + format("%02d", now.min) + " PM";
    } else {
        dt.msg = format("%02d", now.hour - 12) + ":" + format("%02d", now.min) + " PM";
    }
    
    return dt.msg;
}

fe.add_ticks_callback(this, "update_clock");

dt <- fe.add_text("", 440, 25, 200, 40);
dt.align = Align.Centre;
dt.charsize = 30;
dt.set_rgb(255, 255, 255);

function updateTimestamp() // Short
{
    days <- [ "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday" ]
    months <- [ "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" ]
    now <- date()
    return days[now.wday] + ", " + months[now.month + 0] + " " + now.day + "  " + now.year
}

timestamp <- fe.add_text ( "[!updateTimestamp]", 240, 75, 600, 40 )
timestamp.align = Align.Centre;
timestamp.charsize = 30;
timestamp.set_rgb( 255, 255, 255 );

local artworksurf=fe.add_surface(1080,1920)
artworksurf.set_pos( 0,0)
artworksurf.alpha=0

local text = artworksurf.add_text( "[Overview]", 50, 1200, 1000, 600);
text.charsize = 24;
text.word_wrap = true;
text.align = Align.TopLeft;


local year= artworksurf.add_text( "[Year]", 200, 450, 150, 20);
year.charsize = 35;
year.align = Align.Left;
local year= artworksurf.add_text( "[Manufacturer]", 440, 450, 200, 20);
year.charsize = 35;
year.align = Align.Centre;
local year= artworksurf.add_text( "Players: [Players]", 700, 450, 200, 20);
year.charsize = 35;
year.align = Align.Left;  


local boxes=artworksurf.add_artwork("flyer" 20,700,200,300)//////////////
local boxes2=artworksurf.add_artwork("flyer" 860,700,200,300)///////////////

local marquee=artworksurf.add_artwork("marquee" 540,1550,800,250)
marquee.anchor=Anchor.Centre

local mask = fe.add_image("artwork/M3.png");
mask.visible = false;
marquee.shader = ::fe.add_shader(Shader.Fragment, "artwork/mask.frag");///////////mask for rounded corners on marquee
marquee.shader.set_texture_param("mask", mask);


local wheel=artworksurf.add_artwork("wheel", 240,150,600,300)
wheel.preserve_aspect_ratio=true


/////////////////////
//Delayed Video code by Oomek
/////////////////////

local last_nav = 0;
local gtime = 0;
local art_flag = true;

local video = artworksurf.add_image( fe.get_art("snap"),540, 800, 600, 600 );  //Use add_image so the snap doesn't auto-update while navigating
video.anchor=Anchor.Centre


local mask = artworksurf.add_image("artwork/M2.png");//////////////////
mask.visible = false;
video.shader = ::fe.add_shader(Shader.Fragment, "artwork/mask.frag");///////////mask for rounded corners on snap
video.shader.set_texture_param("mask", mask);////////////////////////////


fe.add_transition_callback( "my_transition" );
function my_transition( ttype, var, ttime )
{
    if ( ttype == Transition.FromOldSelection || Transition.ToNewList )
    {
        last_nav = gtime;
        art_flag = true;
        video.video_playing = false
    }
}

fe.add_ticks_callback( this, "on_tick" );
function on_tick( ttime )
{
    gtime = ttime;
    if (art_flag && (ttime - last_nav > 1800))  //400ms delay
    {
        video.file_name = fe.get_art("snap");
        art_flag = false;
        video.video_playing = true
    }
    if ( video.video_playing == false && video.preserve_aspect_ratio == false)
        video.preserve_aspect_ratio = true
}


local game = fe.add_text ( "[ListEntry]/[ListSize]", 440, 1700, 200, 55 );
game.align = Align.Centre;

local S1=fe.add_surface(1080,1920)
S1.x=0
S1.y=0

local S3=fe.add_surface(1080,1920)
S3.x=0
S3.y=0

local S2=fe.add_surface(1080,1920)
S2.x=0
S2.y=0

local S4=fe.add_surface(1080,1920)
S4.x=0
S4.y=0

local BladeS1=S1.add_image("artwork/BL3.png",0,1080,1080,1920)
local BladeS3=S3.add_image("artwork/TR3.png",0,-1080,1080,1920)
local BladeS2=S2.add_image("artwork/TL3.png",0,-1080,1080,1920)
local BladeS4=S4.add_image("artwork/BR3.png",0,1080,1080,1920)
local glowS1=S1.add_image("artwork/glowBL.png",0,1080,1080,1920)
local glowS3=S3.add_image("artwork/glowTR.png",0,-1080,1080,1920)
local glowS2=S2.add_image("artwork/glowTL.png",0,-1080,1080,1920)
local glowS4=S4.add_image("artwork/glowBR.png",0,1080,1080,1920)

artworksurf= Inertia( artworksurf, 500,"x","y","alpha");
text= Inertia( text, 29500,"x","y","alpha");
S1 = Inertia( S1, 500,"x","y");
S3 = Inertia( S3, 500,"x","y");
S2 = Inertia( S2, 500,"x","y");
S4 = Inertia( S4, 500,"x","y");
BladeS1 = Inertia( BladeS1, 500,"x","y");
BladeS3= Inertia( BladeS3, 500,"x","y");
BladeS2 = Inertia( BladeS2, 500,"x","y");
BladeS4 = Inertia( BladeS4, 500,"x","y");
glowS1 = Inertia( glowS1 , 2500,"alpha","y");
glowS3 = Inertia( glowS3 , 2500,"alpha","y");
glowS2 = Inertia( glowS2 , 2500,"alpha","y");
glowS4 = Inertia( glowS4 , 2500,"alpha","y");


     function S1 (ttype, var, ttime )
     {
         if(  ttype==Transition.ToNewSelection|| ttype==Transition.StartLayout)
         {
               artworksurf.alpha=0
               artworksurf.to_alpha=255			   
			   artworksurf.delay_alpha=2000;
			   text.tween_y= Tween.Linear;
			   text.y=1400;
			   text.to_y=700
			   text.loop_y=true
			   BladeS1.y=1080   
			   BladeS1.to_y=0            
			   BladeS1.delay_y=500;
			   BladeS3.y=-1080
               BladeS3.to_y=0			   
			   BladeS3.delay_y=700;
			   BladeS2.y=-1080
			   BladeS2.to_y=0            
			   BladeS2.delay_y=900;
			   BladeS4.y=1080
			   BladeS4.to_y=0            
			   BladeS4.delay_y=700;
			   S1.y=0
			   S3.y=0
			   S2.y=0
			   S4.y=0
			   glowS1.y=1080   
			   glowS1.to_y=0 
			   glowS1.time_y=500
			   glowS1.delay_y=500;
			   glowS1.alpha=0
			   glowS1.to_alpha=255;
			   glowS1.loop_alpha=true
			   glowS1.tween_alpha= Tween.FullSine;
			   glowS3.y=-1080
               glowS3.to_y=0
               glowS3.time_y=500			   
			   glowS3.delay_y=700;
			   glowS3.alpha=0
			   glowS3.to_alpha=255;
			   glowS3.loop_alpha=true
			   glowS3.tween_alpha= Tween.FullSine;
			   glowS2.y=-1080
			   glowS2.to_y=0 
               glowS2.time_y=500			   
			   glowS2.delay_y=900
			   glowS2.alpha=0
			   glowS2.to_alpha=255;
			   glowS2.loop_alpha=true
			   glowS2.tween_alpha= Tween.FullSine;
			   glowS4.y=1080
			   glowS4.to_y=0 
               glowS4.time_y=500			   
			   glowS4.delay_y=700;
			   glowS4.alpha=0
			   glowS4.to_alpha=255;
			   glowS4.loop_alpha=true
			   glowS4.tween_alpha= Tween.FullSine;	  
         }
         if( ttype == Transition.EndNavigation || ttype==Transition.StartLayout)
		 {
		     S1.to_y=1080   			             
		     S3.to_y=-1080               		   			  
			 S2.to_y=-1080			             			  
			 S4.to_y=1080	
             S1.delay_y=2100   			             
		     S3.delay_y=1900               		   			  
			 S2.delay_y=1700			             			  
			 S4.delay_y=1500				 
			 }


    }

fe.add_transition_callback( "S1" );


















































