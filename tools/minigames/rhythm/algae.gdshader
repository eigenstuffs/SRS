shader_type spatial;
// Source: https://www.shadertoy.com/view/cscyDf
// CC0: Saturday hacking
//  Wanted to make the previous shader look a bit more like underwater travelling
//  through glowing abstract "algae"
//  Some glitches remains but now I need a break

#define ROT(a)      (mat2(vec2(cos(a), sin(a)), vec2(-sin(a), cos(a))))
#define OFF6(n)     (vec2(1.0, 0.0)*ROT(n*tau/6.))
#define SAT(x)      (clamp(x,0.,1.))

//#define APPROX_MATH

const float
  pi        = acos(-1.)
, tau       = 2.*pi
, pi_2      = 0.5*pi
, planeDist = .5
, furthest  = 6.
, fadeFrom  = 4.
;
const vec3
  L  = vec3(0.299, 0.587, 0.114)
, LD = normalize(vec3(0.0, 1.8, 1.0))
;

const vec2
  pathA = vec2(.31, .41)
, pathB = vec2(1.0,sqrt(0.5))
;

const vec4
  U = vec4(0, 1, 2, 3)
  ;

const vec2 off6[6] = vec2[6](
    OFF6(0.)
  , OFF6(1.)
  , OFF6(2.)
  , OFF6(3.)
  , OFF6(4.)
  , OFF6(5.)
  );

const vec2 noff6[6] = vec2[6](
    vec2(-1.0, 0.0)
  , vec2(-0.5, 0.5)
  , vec2( 0.5, 0.5)
  , vec2( 1.0, 0.0)
  , vec2( 0.5,-0.5)
  , vec2(-0.5,-0.5)
  );

// License: Unknown, author: Matt Taylor (https://github.com/64), found: https://64.github.io/tonemapping/
vec3 aces_approx(vec3 v) {
  v = max(v, 0.0);
  v *= 0.6f;
  float a = 2.51f;
  float b = 0.03f;
  float c = 2.43f;
  float d = 0.59f;
  float e = 0.14f;
  return clamp((v*(a*v+b))/(v*(c*v+d)+e), 0.0f, 1.0f);
}


vec3 offset(float z) {
  return vec3(pathB*sin(pathA*z), z);
}

vec3 doffset(float z) {
  return vec3(pathA*pathB*cos(pathA*z), 1.0);
}

vec3 ddoffset(float z) {
  return vec3(-pathA*pathA*pathB*sin(pathA*z), 0.0);
}

// License: Unknown, author: Unknown, found: don't remember
float hash(float co) {
  co += 123.4;
  return fract(sin(co*12.9898) * 13758.5453);
}

// License: Unknown, author: Unknown, found: don't remember
float hash2(vec2 co) {
  co += 123.4;
  return fract(sin(dot(co.xy ,vec2(12.9898,58.233))) * 13758.5453);
}

#ifdef APPROX_MATH
// License: MIT, author: Pascal Gilcher, found: https://www.shadertoy.com/view/flSXRV
float atan_approx(float y, float x) {
  float cosatan2 = x / (abs(x) + abs(y));
  float t = pi_2 - cosatan2 * pi_2;
  return y < 0.0 ? -t : t;
}

float acos_approx(float x) {
  return atan_approx(sqrt(1.0 - x*x), x);
}
#else
float atan_approx(float y, float x) {
  return atan(y, x);
}

float acos_approx(float x) {
  return acos(x);
}
#endif

// License: Unknown, author: Martijn Steinrucken, found: https://www.youtube.com/watch?v=VmrIDyYiJBA
vec2 hextile(inout vec2 p) {
  // See Art of Code: Hexagonal Tiling Explained!
  // https://www.youtube.com/watch?v=VmrIDyYiJBA
  const vec2 sz       = vec2(1.0, sqrt(3.0));
  const vec2 hsz      = 0.5*sz;

  vec2 p1 = mod(p, sz)-hsz;
  vec2 p2 = mod(p - hsz, sz)-hsz;
  vec2 p3 = dot(p1, p1) < dot(p2, p2) ? p1 : p2;
  vec2 n = ((p3 - p + hsz)/sz);
  p = p3;

  n -= vec2(0.5);
  // Rounding to make hextile 0,0 well behaved
  return round(n*2.0)*0.5;
}

float dot2(vec2 p) {
  return dot(p, p);
}

// License: MIT, author: Inigo Quilez, found: https://iquilezles.org/www/articles/distfunctions2d/distfunctions2d.htm
float bezier(vec2 pos, vec2 A, vec2 B, vec2 C) {
    vec2 a = B - A;
    vec2 b = A - 2.0*B + C;
    vec2 c = a * 2.0;
    vec2 d = A - pos;
    float kk = 1.0/dot(b,b);
    float kx = kk * dot(a,b);
    float ky = kk * (2.0*dot(a,a)+dot(d,b)) / 3.0;
    float kz = kk * dot(d,a);
    float res = 0.0;
    float p = ky - kx*kx;
    float p3 = p*p*p;
    float q = kx*(2.0*kx*kx-3.0*ky) + kz;
    float h = q*q + 4.0*p3;
    if( h >= 0.0)
    {
        h = sqrt(h);
        vec2 x = (vec2(h,-h)-q)/2.0;
        vec2 uv = sign(x)*pow(abs(x), vec2(1.0/3.0));
        float t = clamp( uv.x+uv.y-kx, 0.0, 1.0 );
        res = dot2(d + (c + b*t)*t);
    }
    else
    {
        float z = sqrt(-p);
        float v = acos_approx( q/(p*z*2.0) ) / 3.0;
        float m = cos(v);
        float n = sin(v)*1.732050808;
        vec3  t = clamp(vec3(m+m,-n-m,n-m)*z-kx,0.0,1.0);
        res = min( dot2(d+(c+b*t.x)*t.x),
                   dot2(d+(c+b*t.y)*t.y) );
        // the third root cannot be the closest
        // res = min(res,dot2(d+(c+b*t.z)*t.z));
    }
    return sqrt( res );
}

// License: CC BY-NC-SA 3.0, author: Martijn Steinrucken, found: https://www.youtube.com/watch?v=VmrIDyYiJBA
// License: CC BY-NC-SA 3.0, author: BigWings, found: https://www.shadertoy.com/view/4sXBRn
vec3 godray(vec3 bg, vec3 r) {
  // Godrays "borrowed" from BigWings amazing Luminescence: https://www.shadertoy.com/view/4sXBRn
  float x = atan_approx(r.x, r.z);
  float y = pi*0.5-acos_approx(r.y);

  x *= 0.5;
  y *= 0.5;

  vec3 col = bg*(1.+y);

  float t = TIME;

  float a = sin(r.x);

  float beam = SAT(sin(10.*x+a*y*5.+t));
  beam *= SAT(sin(7.*x+a*y*3.5-t));

  float beam2 = SAT(sin(42.*x+a*y*21.-t));
  beam2 *= SAT(sin(34.*x+a*y*17.+t));

  beam += beam2;

  col += beam*.25*sqrt(bg);
  return col;
}

vec2 coff(float h) {
  float h0 = h;
  float h1 = fract(h0*9677.0);
  float t = 0.75*mix(0.5, 1.0, h0*h0)*(TIME+1234.5);
  return mix(0.1, 0.2, h1*h1)*sin(t*vec2(1.0, sqrt(0.5)));
}

vec3 plane(vec3 ro, vec3 rd, vec3 pp, float pd, vec3 off, float n) {
  float ppd = pp.z-ro.z;
  vec2 p = (pp-off*U.yyx).xy;
  float hh = hash(n);
  p *= mix(1.125, 1.5, hh*hh);

  vec2 p2 = p;
  mat2 rot = ROT(tau*0.125*n+0.0005*TIME);
  p2 *= rot;
  p2 += -vec2(0.0, hh*0.25*(ro.z-pp.z))*rot;
  vec2 hp = p2;
  hp += 0.5;
  const float ga = 100.0;
  const float z = 1.0/3.0;
  hp /= z;
  vec2 hn = hextile(hp);

  float h0 = hash2(hn+n);
  vec2 p0 = coff(h0);

  vec3 bcol = (1.0/3.0)*(1.0+cos(vec3(0.0, 1.0, 2.0) + 2.0*(p2.x+p2.x)-+0.33*n));
  vec3 col = vec3(0.0);

  float mx = 0.00025+0.0005*max(pd- 1.5, 0.0);

  for (int i = 0; i < 6; ++i) {
    float h1 = hash2(hn+noff6[i]+n);
    vec2 p1 = off6[i]+coff(h1);

    float h2 = h0+h1;
    float fade = smoothstep(1.05, 0.85, distance(p0, p1));

    if (fade < 0.0125) continue;

    vec2 p2 = 0.5*(p1+p0)+coff(h2);
    float dd = bezier(hp, p0, p2, p1);
    float gd = abs(dd);
    gd *= sqrt(gd);
    gd = max(gd, mx);

    col += fade*0.002*bcol/(gd);
  }

  {
    float cd = length(hp-p0);
    float gd = abs(cd);
    gd *= (gd);
    gd = max(gd, mx);
    float fd = ppd;
    fd -= 5.;
    float fade = hash(floor(TIME*5.0+123.0*h0))>(fd+length(hn)) ? 1.0 : 0.125;
    col += 0.0025*fade*sqrt(bcol)/(gd);
  }

  col *= 1.25;
  return col;
}

float hf0(vec2 p) {
  float h = (0.5+0.5*sin(p.x)*sin(p.y));
  h *= h;
  h *= h;
  h *= h;
  return -h;
}

float hf(vec2 p) {
  const float aa = 0.66;
  const mat2 pp = 2.03*ROT(1.0);
  float a = 1.0;
  float h = 0.0;
  float ta = 0.0;
  for (int i = 0; i < 3; ++i) {
    p += a*0.05*TIME;
    h += a*hf0(p);
    a *= aa;
    ta += a;
    p *= pp;
  }
  return 0.1*h/ta;
}

vec3 nf(vec2 p, vec2 resolution) {
  vec2 v;
  vec2 w;
  vec2 e = vec2(4.0/resolution.y, 0);

  vec3 n;
  n.x = hf(p + e.xy) - hf(p - e.xy);
  n.y = hf(p + e.yx) - hf(p - e.yx);
  n.z = -2.0*e.x;

  return normalize(n);
}


vec3 color(vec3 ww, vec3 uu, vec3 vv, vec3 ro, vec2 p, vec2 resolution) {
  float lp = length(p);
  vec2 np = p + 1.0/resolution.y;
  float rdd = 2.0-0.25;

  vec3 rd = normalize(p.x*uu + p.y*vv + rdd*ww);

  float nz = floor(ro.z / planeDist);

  vec3 acol = vec3(0.0);

  vec3 aro = ro;
  float apd = 0.0;
  vec3 ard = rd;

  for (float i = 1.; i <= furthest; ++i) {
    float pz = planeDist*nz + planeDist*i;

    float lpd = (pz - aro.z)/ard.z;

    {
      vec3 pp = aro + ard*lpd;

      vec3 nor = nf(pp.xy, resolution);
      apd += lpd;

      vec3 off = offset(pp.z);

      float dz = pp.z-ro.z;
      float fadeIn = smoothstep(planeDist*furthest, planeDist*fadeFrom, dz);
      float fadeOut = smoothstep(0., planeDist*.1, dz);
      float fadeOutRI = smoothstep(0., planeDist*1.0, dz);

      float ri = mix(1.0, 0.9, fadeOutRI*fadeIn);
      vec3 refr = refract(ard, nor, ri);

      vec3 pcol = plane(ro, ard, pp, apd, off, nz+i);

      pcol *= fadeOut*fadeIn;
      pcol *= exp(-vec3(0.8, 0.9, .7)*apd);
      acol += pcol;
      aro = pp;
      ard = refr;
    }

  }

  float lf = 1.001-dot(ard, LD);
  lf *= lf;
  acol += godray(0.025*vec3(0.0, 0.25, 1.0)/lf, rd);
  return acol;

}

void fragment() {
  vec2 r = VIEWPORT_SIZE.xy, q = FRAGCOORD.xy/VIEWPORT_SIZE.xy, pp = -1.0+2.0*q, p = pp;
  p.x *= r.x/r.y;

  float tm  = 0.125*planeDist*TIME-0.1*sin(0.25*TIME-pp.y+pp.x)*length(pp);

  vec3 ro   = offset(tm);
  vec3 dro  = doffset(tm);
  vec3 ddro = ddoffset(tm);

  vec3 ww = normalize(dro);
  vec3 uu = normalize(cross(U.xyx+ddro, ww));
  vec3 vv = cross(ww, uu);

  vec3 col = color(ww, uu, vv, ro, p, VIEWPORT_SIZE);
  col -= (1.0/30.0)*U.zwx*(length(pp)+0.125);
  float fade = min(-0.5*abs(pp.y)+0.125*TIME-1.5, 0.0);
  col *= smoothstep(1.5, sqrt(0.5), length(pp)-fade);
  col = aces_approx(col);
  col = sqrt(col);
  ALBEDO = col*0.45;
}
