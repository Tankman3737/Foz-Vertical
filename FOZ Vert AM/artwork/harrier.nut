///////////////////////////////////////////////////
//
// Attract-Mode Frontend - "harrier" module
//
// by Oomek 2017
//
/*
///////////////////////////////////////////////////
// 
// This is a simple snap/video selector module
// It has smooth scrolling and does not freeze other animations
// 
///////////////////////////////////////////////////

USAGE EXAMPLES:

local harrier = harrier( 0, 400, 1920, 300, 5, 3, 20 )
or
local harrier = harrier( 0, 400, 1920, 300, 5, 3, 20, "selector.png", "background.png" )

It's (STRONGLY) advised to set:
selection_speed_ms 51
in your attract.cfg

///////////////////////////////////////////////////

PARAMETERS:

harrier( harrierPosX, harrierPosY, harrierWidth, harrierHeight, tilesCount, tilesOffscreen, tilePadding[, selectorImage, backgroundImage] ) 

    harrierPosX - x position of harrier surface in pixels
    harrierPosY - y position of harrier surface in pixels
    harrierWidth - width of the harrier surface in pixels
    harrierHeight - height of the harrier surface in pixels
    
    if harrierWidth is greater than harrierHeight the orientation of tiles will be horizontal
    if harrierWidth is smaller than harrierHeight the orientation of tiles will be vartical
    
    tilesCount - number of visible snaps in a row or column
    
    tilesOffscreen - number of snaps outside of the screen ( 1 to 3 recommended )
                     It helps with fast scrolling by preloading snaps/videos outside the screen.
                     Mostly helpful if your videos have fade-in

    tilePadding - space between tiles, if set to 0 selector will not be visible, unless set to be on top
    
    selectorImage - the png file that will be used instead of the selector rectangle. Can be transparent.
    
    selectorBackground - png that will be stretched across the whole harrier surface

///////////////////////////////////////////////////

FUNCTIONS:    

    harrier.set_selector_color( red, green, blue ) - sets the color of the selector rectangle if no file was specified
    
    harrier.set_background_color( red, green, blue )  - sets the color of the harrier surface background if no file was specified
    
    harrier.set_snap_videos() - switches snaps to videos
    
    harrier.set_selector_on_top() - moves selector on top of the snaps. Useful if your selector is a transparent png
    
    harrier.surfacePosSmoothing = 0.9 - controls the speed of scrolling ( typically between 0.5 and 0.99 )
    
    harrier.set_keep_aspect() - turns the aspect ratio for snaps/videos. by default snaps are stretched.

///////////////////////////////////////////////////

*/
///////////////////////////////////////////////////
const harrier_VERSION = 1.0;
///////////////////////////////////////////////////

class harrier {
    surfacePosSmoothing = 0.9
    fileSelector = null
    fileBackground = null
    
    tileHeight = 0
    tileWidth = 0
    surfacePosOffset = 0
    vertical = false    
    tilesTable = []
    tilesTablePos = []
    tilesTableOffset = 0
    surfacePos = 0
    surface = null
    surfaceBackground = null
    selector = null
    tilesTotal = 0
    harrierWidth = 0
    harrierHeight = 0
    tilePadding = 10
    tilesOffscreen = 3
        
    constructor( harrierPosX, harrierPosY, harrierWidth, harrierHeight, tilesCount, _tilesOffscreen, _tilePadding, ... ) {
		if( vargv.len() > 1) fileBackground = vargv[1]
        if( vargv.len() > 0) fileSelector = vargv[0]
        
        tilePadding = _tilePadding
        tilesOffscreen = _tilesOffscreen
        tilesTotal = tilesCount + tilesOffscreen * 2
        if( harrierHeight > harrierWidth) vertical = true
        if( vertical ) {
            tileWidth = harrierWidth
            tileHeight = harrierHeight / tilesCount
            surfacePosOffset = tilesOffscreen * tileHeight
        } else {
            tileWidth = harrierWidth / tilesCount
            tileHeight = harrierHeight
            surfacePosOffset = tilesOffscreen * tileWidth
        }    

        surface = fe.add_surface( harrierWidth, harrierHeight )
        surface.set_pos( harrierPosX, harrierPosY )
			//surface.rotation=-35

        if ( fileBackground != null ) surfaceBackground = surface.add_image( fileBackground, 0, 0, harrierWidth, harrierHeight )
        else {
            surfaceBackground = surface.add_text( "", 0, 0, harrierWidth, harrierHeight )
            surfaceBackground.set_bg_rgb( 50, 50, 50 )
        }

        if( fileSelector != null ) selector = surface.add_image( fileSelector, 0, 0, tileWidth, tileHeight)
        else {
            selector = surface.add_text( "", 0, 0, tileWidth, tileHeight)
            selector.set_bg_rgb( 200, 200, 200 )
        }

        local index = -floor( tilesTotal / 2 )
        for( local i = 0; i < tilesTotal; i++ ) {
            local obj = surface.add_artwork( "wheel" )
            if( vertical ) {
                tilesTablePos.push( tileWidth * i + ( tilePadding / 2 ) )
                obj.set_pos( tilePadding, 0, tileWidth - tilePadding * 2, tileHeight - tilePadding * 2 )
            } else {
                tilesTablePos.push( tileHeight * i + ( tilePadding / 2 ) )
                obj.set_pos(0, tilePadding, tileWidth - tilePadding * 2, tileHeight - tilePadding * 2 )
            }
            //obj.preserve_aspect_ratio = false
            obj.index_offset = index
            obj.video_flags = Vid.ImagesOnly
			//obj.rotation=35
            tilesTable.push( obj )
			
		
			//ADDED BY ME
			
				local an = { when=Transition.ToNewSelection, property="alpha", start=255, end=0,delay =1500,time=1000 }
animation.add( PropertyAnimation( obj, an ) );
  local an2 = { when=Transition.FromOldSelection, property="alpha", start=255, end=255,time=1 }
animation.add( PropertyAnimation( obj, an2 ) );


            index++
			
			
			
			
			
			
        }
        surfacePos = 0.5

        ::fe.add_transition_callback( this, "on_transition" )
        ::fe.add_ticks_callback( this, "tick" )
    }

    
    function on_transition( ttype, var, ttime ) {
        if ( ttype == Transition.ToNewSelection || ttype == Transition.StartLayout) {
            local index = -floor( tilesTotal / 2 )
            tilesTableOffset += var
            for ( local i = 0; i < tilesTotal; i++ ) {
                local indexTemp = wrap( i + tilesTableOffset, tilesTotal )
                tilesTable[ indexTemp ].rawset_index_offset( index );
                if( vertical ) {
                    tilesTablePos[ indexTemp ] = i * tileHeight + tilePadding
                } else {
                    tilesTablePos[ indexTemp ] = i * tileWidth + tilePadding
                }
                index++
            }
            if( ttype == Transition.ToNewSelection )
            {
                if ( vertical ) surfacePos += var * tileHeight
                else surfacePos += var * tileWidth
            }
        }
        return false
    }

    function tick( tick_time ) {
        if ( surfacePos != 0 ) {
            if ( surfacePos < 0.1 && surfacePos > -0.1 ) surfacePos = 0
            surfacePos = surfacePos * surfacePosSmoothing
            if ( surfacePos > surfacePosOffset) surfacePos = surfacePosOffset
            if ( surfacePos < -surfacePosOffset) surfacePos = -surfacePosOffset
            for ( local i = 0; i < tilesTotal; i++ ) {
                if( vertical ) {
                    tilesTable[ i ].y = surfacePos - surfacePosOffset + tilesTablePos[ i ]
                    selector.y = tilesTotal / 2 * tileHeight + surfacePos - surfacePosOffset
                } else {
                    tilesTable[ i ].x = surfacePos - surfacePosOffset + tilesTablePos[ i ]
                    selector.x = tilesTotal / 2 * tileWidth + surfacePos - surfacePosOffset
                }
            }
        }
    }

    // wrap around value witin range 0 - N
    function wrap( i, N ) { 
      while ( i < 0 ) { i += N }
      while ( i >= N ) { i -= N }
      return i
    }
    
    function set_selector_color( r, g ,b )
    {
        try { selector.set_bg_rgb( r, g, b ); selector.alpha = 10 }
        catch(e) {}
    }
    
    function set_background_color( r, g ,b )
    {
        try{ surfaceBackground.set_bg_rgb( r, g, b ) }
        catch(e) {}
    }
    
    function set_snap_videos()
    {
        for ( local i = 0; i < tilesTotal; i++ )
            tilesTable[i].video_flags = Vid.NoAudio
    }
    
    function set_selector_on_top()
    {
        selector.zorder = 9999
    }
    
    function set_keep_aspect ()
    {
        for ( local i = 0; i < tilesTotal; i++ )
            tilesTable[i].preserve_aspect_ratio = true
    }
}
