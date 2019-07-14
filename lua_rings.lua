require 'cairo'

font="Mono"
font_size=12
red,green,blue,alpha=1,1,1,1
font_slant=CAIRO_FONT_SLANT_NORMAL
font_face=CAIRO_FONT_WEIGHT_NORMAL

settings_table = {
    {
        title="Signal strength",
        text_suffix='/70 Wifi',
        cmd="iwconfig 2>&1 | grep Quality | cut -d'=' -f2 | cut -d'/' -f1",

              x=65,
         text_x=30,
        title_x=10,

              y=65,
         text_y=67,
        title_y=150,

        max=70,
        bg_colour=0xffffff,
        bg_alpha=0.1,
        fg_colour=0xFF6600,
        fg_alpha=0.1,
        radius=50,
        thickness=15,
        start_angle=0,
        end_angle=270
    },
    {
        title="Ping to gateway",
        text_suffix='/50 ms',
        cmd="ping -w 2 -c 1 $(ip route | awk '/default/ { print $3 }') | grep ttl | cut -d '=' -f 4 | awk '{print $1}' | cut -d'.' -f1",

              x=265,
         text_x=235,
        title_x=210,

              y=65,
         text_y=67,
        title_y=150,

        max=50,
        bg_colour=0xffffff,
        bg_alpha=0.1,
        fg_colour=0xFF6600,
        fg_alpha=0.1,
        radius=50,
        thickness=15,
        start_angle=0,
        end_angle=270
    },
    {
        title="Battery status.",
        text_suffix='/100%',
        cmd="cat /sys/class/power_supply/BAT*/capacity",

              x=465,
         text_x=435,
        title_x=410,

              y=65,
         text_y=67,
        title_y=150,

        max=100,
        bg_colour=0xffffff,
        bg_alpha=0.1,
        fg_colour=0xFF6600,
        fg_alpha=0.1,
        radius=50,
        thickness=15,
        start_angle=0,
        end_angle=270
    },

}

function rgb_to_r_g_b(colour,alpha)
    return ((colour / 0x10000) % 0x100) / 255., ((colour / 0x100) % 0x100) / 255., (colour % 0x100) / 255., alpha
end

function draw_ring(cr,t,pt)
    local w,h=conky_window.width,conky_window.height

    local xc,yc,ring_r,ring_w,sa,ea=pt['x'],pt['y'],pt['radius'],pt['thickness'],pt['start_angle'],pt['end_angle']
    local bgc, bga, fgc, fga=pt['bg_colour'], pt['bg_alpha'], pt['fg_colour'], pt['fg_alpha']

    local angle_0=sa*(2*math.pi/360)-math.pi/2
    local angle_f=ea*(2*math.pi/360)-math.pi/2
    local t_arc=t*(angle_f-angle_0)

    -- Draw background ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_f)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(bgc,bga))
    cairo_set_line_width(cr,ring_w)
    cairo_stroke(cr)

    -- Draw indicator ring

    cairo_arc(cr,xc,yc,ring_r,angle_0,angle_0+t_arc)
    cairo_set_source_rgba(cr,rgb_to_r_g_b(fgc,fga))
    cairo_stroke(cr)        
end

function conky_lua_rings()
    local function setup_rings(cr,pt)
        local value=0
        local handle = io.popen(pt['cmd'])
        local result = handle:read("*a")
                       handle:close()
              value = tonumber(result)
        if ( value == nil ) then value = 0 end
              pct = value/pt['max']

        cairo_select_font_face (cr, font, font_slant, font_face);
        cairo_set_font_size (cr, font_size)
        cairo_set_source_rgba (cr,red,green,blue,alpha)
        cairo_move_to (cr,pt['text_x'],pt['text_y'])
        cairo_show_text (cr,value .. pt['text_suffix'])

        cairo_move_to (cr,pt['title_x'],pt['title_y'])
        cairo_show_text (cr,pt['title'])
        cairo_stroke (cr)

        draw_ring(cr,pct,pt)
    end

    -- Check that Conky has been running for at least 5s

    if conky_window==nil then return end
    local cs=cairo_xlib_surface_create(conky_window.display,conky_window.drawable,conky_window.visual, conky_window.width,conky_window.height)
    local cr=cairo_create(cs)
    local updates=conky_parse('${updates}')
    update_num=tonumber(updates)

    if update_num>5 then
        for i in pairs(settings_table) do
            setup_rings(cr,settings_table[i])
        end
    end
end
