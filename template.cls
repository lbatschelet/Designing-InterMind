% template.cls
% Lukas Batschelet
% 2025-08-16
% Persönliche LaTeX Template Klasse


\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2024/12/19 My custom template class]
\raggedbottom

% Basierend auf article
\LoadClass[fontsize=10.4pt,a4paper]{scrreprt}
\KOMAoptions{toc=flat}

% ---------------------- Pakete für Layout ----------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

% Grundlayout / Tabellen / Sonstiges (reihenfolge unkritisch)
\RequirePackage{ragged2e}
\RequirePackage{lipsum}

% --- Math (nur Infrastruktur; keine Formeln nötig) ---
\RequirePackage{amsmath}   % vor hyperref/cleveref laden
\let\openbox\relax
\RequirePackage{amsthm}
\RequirePackage{amsfonts}
\RequirePackage{amscd}

% Tabellen & Co.
\RequirePackage{booktabs}
\RequirePackage{array}
\RequirePackage{tabularray}
\RequirePackage{float}
\RequirePackage{multirow}
\RequirePackage{makecell}
\RequirePackage[nottoc]{tocbibind}
\RequirePackage{pdflscape}
\RequirePackage{longtable}
\RequirePackage{ltablex}
\RequirePackage{threeparttablex}
\RequirePackage{etoolbox}
\RequirePackage{pdfpages}
\RequirePackage{ccicons}
\keepXColumns


% --- Schriften ---
% 1) Fira Sans als Standardsans (OHNE Option 'light')
\RequirePackage[sfdefault]{FiraSans}
\renewcommand{\familydefault}{\sfdefault}

% 2) Sans-Math (nicht Fira Math, sondern newtxsf)
\RequirePackage{newtxsf}

% 3) Ab Dokumentstart Textserie auf 'Light' stellen (nur Text, nicht Math)
\AtBeginDocument{\firalight}

% 4) Sicherheit: Math immer in 'normal' lassen (unterdrückt etwaige light-Switches)
\everymath{\mathversion{normal}}
\everydisplay{\mathversion{normal}}

% Überschriften: URW Grotesk (UGQ)
\newcommand{\headingfont}{\fontfamily{ugq}\selectfont}

% --- Überschriftengestaltung ---
\RequirePackage{titlesec}
\titleformat{\part}{\headingfont\LARGE\bfseries\raggedright\color{black}}{\thepart}{1em}{}
\titleformat{\chapter}{\headingfont\Large\bfseries\raggedright\color{black}}{\thechapter}{1em}{}
\titleformat{\section}{\headingfont\large\bfseries\raggedright\color{black}}{\thesection}{1em}{}
\titleformat{\subsection}{\sffamily\bfseries\normalsize\raggedright\color{black}}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\normalsize\bfseries\raggedright\color{black}}{\thesubsubsection}{1em}{}
\titlespacing*{\chapter}{0pt}{*2}{1em}

\AtBeginEnvironment{tabular}{\firalight}
\AtBeginEnvironment{tabular*}{\firalight}

\RequirePackage[nswissgerman]{babel}

% =====================================================
% Appendix-Setup (für Klassen ohne \chapter, z.B. article, eigene .cls)
% =====================================================
\RequirePackage[toc, page]{appendix}      % KEINE Optionen 'toc,page' hier!
\RequirePackage{etoc}          % Für lokales TOC im Anhang (optional)

% Deutsche Begriffe
\renewcommand{\appendixpagename}{Anhang}   % Überschrift auf der Anhang-Seite
\renewcommand{\appendixtocname}{Anhang}    % Eintrag im Haupt-ToC
\addto\captionsnswissgerman{%
  \renewcommand{\abstractname}{Abstract}%
}

\makeatletter
\renewcommand\appendixpage{
  \section*{\appendixpagename}
}
\makeatother

\RequirePackage[format=plain,labelfont=bf,labelsep=colon]{caption}

\captionsetup{
  format=plain,
  justification=raggedright,
  labelfont=bf,
  labelsep=space
}
 
% ---------------------------------------

\RequirePackage{siunitx}
\sisetup{
  round-mode=places,
  round-precision=1,
  table-number-alignment = center,
  minimum-decimal-digits = 0,
  drop-zero-decimal = true,
  output-decimal-marker = {.},
  table-format = 1.2,
  detect-family,
  detect-weight
}
\newcommand{\var}[1]{\texttt{\footnotesize #1}}


\RequirePackage{geometry}
\geometry{a4paper, left=3cm, right=3cm, top=2.5cm, bottom=2.5cm}

\RequirePackage{setspace}
\setstretch{1.3}

\RequirePackage{microtype}
% \DisableLigatures{encoding = *, family = * }

\RequirePackage[dvipsnames, table]{xcolor}

\definecolor{rowgray}{gray}{0.95}
\definecolor{Headercolor}{HTML}{29317a}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=Headercolor,
    urlcolor=Headercolor
}




\RequirePackage{bookmark}



\RequirePackage[german]{cleveref}
\AtBeginEnvironment{appendices}{\crefalias{section}{appendix}}


% hochgestellter Stern ohne Umbruch an der Stern-Stelle,
% aber mit normaler Hyphenation davor/danach
\DeclareRobustCommand{\genderstern}{%
  \nobreak\hskip0pt%
  \textsuperscript{\textasteriskcentered}%
  \nobreak\hskip0pt%
}




\makeatletter
\patchcmd{\chapter}{\if@openright\cleardoublepage\else\clearpage\fi}{}{}{}
\makeatother

% Kein Umbruch vor \listoffigures
\makeatletter
\patchcmd{\listoffigures}{\clearpage}{}{}{}

% Kein Umbruch vor \listoftables
\patchcmd{\listoftables}{\clearpage}{}{}{}
\makeatother

\RequirePackage{enumitem}

\RequirePackage{fancyhdr}
\pagestyle{fancy}
\fancyhf{}
% Keine Linien:
\renewcommand{\headrulewidth}{0pt}
\renewcommand{\footrulewidth}{0pt}
% Seitenzahl unten rechts:
\fancyfoot[R]{\thepage}

\fancypagestyle{plain}{
  \fancyhf{} % alles leeren
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
  \fancyfoot[R]{\thepage} % Seitenzahl unten rechts
}

% ---------------------- Literatur mit biblatex ----------------------
\RequirePackage[
  style=authoryear,
  backend=biber,
  citetracker=true,
  giveninits=false,
  maxbibnames=999,
  maxcitenames=2,
  mincitenames=1,
  date=year,
  uniquename=false,
  language=swissgerman,
  doi=true,
  isbn=false,
  eprint=false
]{biblatex}

\AtEveryBibitem{%
  \clearfield{note}%
}

% -------------------------------------------------------------
% 2. GLOBALER Namens-Tracker  (nach moewe, ohne Abschnitts-Reset)
% -------------------------------------------------------------
\makeatletter
% zentrale Liste aller schon ausgegebenen Namen
\newcommand*\cbx@seen@names{}

% prüfen, ob Hash schon in Liste
\newrobustcmd*{\cbx@ifnameseen}[1]{\xifinlist{#1}{\cbx@seen@names}}

% Hash in Liste eintragen
\newrobustcmd*{\cbx@nametracker}[1]{%
  \xifinlist{#1}{\cbx@seen@names}%
    {}%
    {\listxadd{\cbx@seen@names}{#1}}}

% Namensformat: voller Name nur, wenn noch nie gesehen
\DeclareNameFormat{firstfullonce}{%
  \nameparts{#1}%        zerlege Name in Teile
  \cbx@ifnameseen{\thefield{hash}}
    {\usebibmacro{name:family}      % schon gesehen → nur Nachname
       {\namepartfamily}{\namepartgiven}
       {\namepartprefix}{\namepartsuffix}}
    {\usebibmacro{name:given-family}% erstes Mal → Vor- & Nachname
       {\namepartfamily}{\namepartgiven}
       {\namepartprefix}{\namepartsuffix}%
     \cbx@nametracker{\thefield{hash}}}% Namen merken
  \usebibmacro{name:andothers}}
\makeatother

% -------------------------------------------------------------
% 3. Nur \textcite überschreiben  (Klammer + Semikolon)
% -------------------------------------------------------------

\makeatletter
\DeclareCiteCommand{\textcite}
  {\usebibmacro{prenote}}
  {%
    % Namen ausgeben: Format "firstfullonce", begrenzt auf min=1, max=2
    \printnames[firstfullonce][1-2]{labelname}%
    \addspace
    % Jahr in runden Klammern, verlinkt
    \mkbibparens{\bibhyperref{\printfield{year}}}%
  }
  {\multicitedelim}
  {\usebibmacro{postnote}}
\makeatother
% -------------------------------------------------------------


% Befehle zum einfachen Einbinden der Bib-Datei und Ausgeben der Bibliographie:
\newcommand{\AddBibFile}[1]{\addbibresource{#1}}
\newcommand{\PrintBib}{\printbibliography}

\DefineBibliographyStrings{nswissgerman}{%
  andothers = {et\addabbrvspace al\adddot} % Definiert "und andere" als "et al."
}

% Makro für URL-Ausgabe anpassen: Nur ausgeben, wenn kein DOI vorhanden ist
\renewbibmacro*{url+urldate}{% Sternchen-Version für saubere Neudefinition
  \iffieldundef{doi} % Prüfe, ob das Feld 'doi' undefiniert/leer ist
    {% Wenn KEIN DOI da ist: Gib URL und Abrufdatum aus
      \usebibmacro{url}% Holt sich die Standard-URL-Formatierung
      \setunit*{\addspace}% Fügt Leerschlag ein, wenn nötig
      \usebibmacro{urldate}% Holt sich die Standard-Abrufdatum-Formatierung
    }
    {% Wenn EIN DOI da ist: Tue nichts (gib keine URL/Abrufdatum aus)
    }%
}

% --- biblatex: Literatur in Fira Sans Light ---
\renewcommand*{\bibfont}{\firalight} % oder \normalsize, wie du willst

% URLs in der Bibliographie: Fira Sans OLDSTYLE + Light erzwingen
\urlstyle{same} % keine Monospace-URL
\makeatletter
\def\UrlFont{%
  \fontencoding{T1}%
  \fontfamily{FiraSans-OsF}% Oldstyle Figures (hat Light)
  \fontseries{l}% Light
  \selectfont}
\makeatother