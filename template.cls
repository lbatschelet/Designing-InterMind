\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{template}[2024/12/19 My custom template class]

% Basierend auf article
\LoadClass[10pt,a4paper]{report}

% ---------------------- Pakete für Layout ----------------------
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage{helvet}    % Serifenlose Schrift für Titel und Überschriften
\RequirePackage{ragged2e}
\RequirePackage{lipsum}
\RequirePackage{mathptmx}  % Times-ähnliche Schrift für den Fliesstext
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{amsthm}
\RequirePackage{amsfonts}
\RequirePackage{amscd}
\RequirePackage{amsthm}
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
\keepXColumns


\renewcommand{\sfdefault}{phv}

\RequirePackage[nswissgerman]{babel}

% =====================================================
% Appendix-Setup (für Klassen ohne \chapter, z.B. article, eigene .cls)
% =====================================================
\RequirePackage[toc, page]{appendix}      % KEINE Optionen 'toc,page' hier!
\RequirePackage{etoc}          % Für lokales TOC im Anhang (optional)

% Deutsche Begriffe
\renewcommand{\appendixpagename}{Anhang}   % Überschrift auf der Anhang-Seite
\renewcommand{\appendixtocname}{Anhang}    % Eintrag im Haupt-ToC

\makeatletter
\renewcommand\appendixpage{
  \section*{\appendixpagename}
}
\makeatother
 
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
\onehalfspacing

\RequirePackage{microtype}
% \DisableLigatures{encoding = *, family = * }

\RequirePackage[dvipsnames, table]{xcolor}
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    citecolor=TealBlue,
    urlcolor=TealBlue
}




\RequirePackage{bookmark}

\definecolor{rowgray}{gray}{0.95}

\RequirePackage[german]{cleveref}
\AtBeginEnvironment{appendices}{\crefalias{section}{appendix}}


\newcommand{\genderstern}{\raisebox{0.55ex}{\small\textasteriskcentered}}



\RequirePackage{titlesec}
\titleformat{\part}{\sffamily\LARGE\bfseries\raggedright}{\thepart}{1em}{}
\titleformat{\chapter}{\sffamily\Large\bfseries\raggedright}{\thechapter}{1em}{}
\titleformat{\section}{\sffamily\large\bfseries\raggedright}{\thesection}{1em}{} 
\titleformat{\subsection}{\sffamily\normalsize\bfseries\raggedright}{\thesubsection}{1em}{}
\titleformat{\subsubsection}{\sffamily\normalsize\bfseries\raggedright}{\thesubsubsection}{1em}{}
\titlespacing*{\chapter}{0pt}{*2}{1em}

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
    % Name(n) – mit Vorname nur beim allerersten Auftreten
    \printnames[firstfullonce]{labelname}%
    \addspace
    % Jahr in runden Klammern, bleibt vollständig verlinkt
    \mkbibparens{\bibhyperref{\printfield{year}}}%
  }
  {\multicitedelim}      % Trennzeichen, falls Sie doch einmal mehrere Schlüssel angeben
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


% ---------------------- Titel- und Metainformationen ----------------------
\newcommand{\ReportTitle}{}
\newcommand{\ReportAuthor}{}
\newcommand{\ReportDate}{\today}

\newcommand{\SetTitle}[1]{\renewcommand{\ReportTitle}{#1}}
\newcommand{\SetAuthor}[1]{\renewcommand{\ReportAuthor}{#1}}
\newcommand{\SetDate}[1]{\renewcommand{\ReportDate}{#1}}

\makeatletter
\renewcommand{\maketitle}{
    % Titel in serifenlos und linksbündig
    \vspace*{-2em}
    \sffamily
    \raggedright
    {\Large\bfseries \ReportTitle \par}
    \vspace{1em}
    {\footnotesize
        \ReportAuthor \\
        \ReportDate
    }
    \par\vspace{2em}

    % Nach dem Titel wieder zurück zu Times (Serif) und Blocksatz
    \normalfont
    \normalsize
    \rmfamily
    \justifying
}
\makeatother

% Tabelle Serifenlos
\AtBeginEnvironment{table}{\sffamily\footnotesize\color{gray!30!black}}
\AtBeginEnvironment{table*}{\sffamily\footnotesize\color{gray!30!black}}

\AtBeginEnvironment{longtable}{\sffamily\footnotesize\color{gray!30!black}}
\AtBeginEnvironment{ltablex}{\sffamily\footnotesize\color{gray!30!black}}

\AtBeginEnvironment{tblr}{\sffamily\footnotesize\color{gray!30!black}}
\AtBeginEnvironment{threeparttable}{\sffamily\footnotesize\color{gray!30!black}}
