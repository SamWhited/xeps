<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:str="http://xsltsl.org/string">
<!--
  * Copyright (c) 2008 - 2010, Tobias Markmann
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions are met:
  *     * Redistributions of source code must retain the above copyright
  *       notice, this list of conditions and the following disclaimer.
  *     * Redistributions in binary form must reproduce the above copyright
  *       notice, this list of conditions and the following disclaimer in the
  *       documentation and/or other materials provided with the distribution.
  *     * Neither the name of the <organization> nor the
  *       names of its contributors may be used to endorse or promote products
  *       derived from this software without specific prior written permission.
  *
  * THIS SOFTWARE IS PROVIDED BY TOBIAS MARKMANN ''AS IS'' AND ANY
  * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  * DISCLAIMED. IN NO EVENT SHALL TOBIAS MARKMANN BE LIABLE FOR ANY
  * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

  Thanks to the XSLT Standard Library http://xsltsl.sourceforge.net/.
-->

<!--<xsl:include href="xsltsl/string.xsl"/>-->
<xsl:import href="http://xsltsl.sourceforge.net/modules/stdlib.xsl"/>

<xsl:output method="text" />

<!-- Create a variable named $maxXEPVersiom containing the MAX version -->
<xsl:variable name="maxXEPVersion">
  <xsl:value-of select='/xep/header/revision[position()=1]/version'/>
</xsl:variable>

<!-- Create a variable named $maxXEPDate containing the MAX date -->
<xsl:variable name="maxXEPDate">
  <xsl:for-each select="/xep/header/revision">
    <xsl:sort select="date" data-type="text" order="descending" />
      <xsl:if test="position() = 1">
        <xsl:value-of select="date" />
      </xsl:if>
  </xsl:for-each>
</xsl:variable>

<!-- Format URLs for the front page. Putting too long URLs in the footnotes. -->
<xsl:template name="formatURL">
  <xsl:param name="url"/>
  <xsl:choose>
    <xsl:when test="string-length($url) > 80">\thanks{\url{<xsl:value-of select="$url"/>}}\hspace{0.5 cm}</xsl:when>
    <xsl:otherwise>
\url{<xsl:value-of select="$url"/>}\\</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- convert "document": create header and continue -->
<xsl:template match="xep">
%!TEX TS-program = xelatex
%!TEX encoding = UTF-8 Unicode
\documentclass[DIV=10]{scrartcl}
\KOMAoptions{paper=a4}

\usepackage[
  pdftitle={XEP-<xsl:value-of select="/xep/header/number"/>: <xsl:value-of select="/xep/header/title"/>},
  pdfauthor={XMPP Standards Foundation},
  pdfcreator={XEP2PDF},
  pdfproducer={XEP2PDF},
  breaklinks = true,
  unicode,
  pagebackref,
  xetex]{hyperref}

% break URLs at more places
\renewcommand{\UrlBreaks}{\do\/\do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l\do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z\do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L\do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z\do\0\do\1}

\usepackage{xcolor}
\usepackage{graphicx}
\usepackage{fancyhdr}
\usepackage{tabu}
\usepackage{longtable}
\usepackage{listings}
\usepackage{varwidth}
\usepackage{titling}
\usepackage{titletoc}
\usepackage{float}
\usepackage{adjustbox}

\usepackage{hyphenat}

\hypersetup{colorlinks, linkcolor=blue, anchorcolor=blue, urlcolor=blue}


\usepackage{fontspec,xltxtra,xunicode}
\defaultfontfeatures{Mapping=tex-text}
\setromanfont[Ligatures={Common}]{Gentium Basic}
\setsansfont[Scale=MatchLowercase]{Gentium Basic}
\setmonofont[Scale=MatchLowercase]{Inconsolata}

\setkomafont{descriptionlabel}{\normalfont\bfseries}

\usepackage[english]{babel}

\pagestyle{fancy}
\fancyfoot{}
\fancyhead{}
%% page numbering

\newcommand{\XEPNumber}[0]{<xsl:value-of select="/xep/header/number"/>}
\newcommand{\XEPVersion}[0]{<xsl:value-of select="$maxXEPVersion"/>}

\newcolumntype{L}{>{\raggedright\arraybackslash}X}

\fancyhead[L,L]{\includegraphics[totalheight=10pt]{xmpp.pdf} \slshape \leftmark}
\fancyfoot[C,C]{\thepage}

\pretitle{
\begin{figure*}[h]
\begin{center}
\includegraphics[totalheight=7.5cm]{xmpp-text.pdf}
\end{center}
\end{figure*}
\begin{center}\LARGE
}

\sloppy

\newcommand*{\xeptitle}{<xsl:value-of select="/xep/header/title"/>}
\newcommand*{\xepnum}{<cmd name="XEPNumber" />}

\title{XEP-\xepnum: \xeptitle}
\author{%
<xsl:for-each select='/xep/header/author'>
  <xsl:value-of select="firstname"/><xsl:text> </xsl:text><xsl:value-of select="surname"/> \\<xsl:if test="email"><xsl:call-template name="formatURL"><xsl:with-param name="url">mailto:<xsl:value-of select="email"/></xsl:with-param></xsl:call-template></xsl:if><xsl:if test="jid"><xsl:call-template name="formatURL"><xsl:with-param name="url">xmpp:<xsl:value-of select="jid"/></xsl:with-param></xsl:call-template></xsl:if><xsl:if test="uri"><xsl:call-template name="formatURL"><xsl:with-param name="url"><xsl:value-of select="uri"/></xsl:with-param></xsl:call-template></xsl:if>
  <xsl:if test='position() != last()'>
\and </xsl:if>
</xsl:for-each>
}
\date{<xsl:value-of select="$maxXEPDate"/>\\ Version <xsl:value-of select="$maxXEPVersion"/>}

\begin{document}

\lstset{language=XML,
  breaklines=true,
  emptylines=5,
  frame=single,
  rulecolor=\color{black},
  basicstyle=\ttfamily\small\color{darkgray},
  keywordstyle=\color{cyan},
  stringstyle=\color{blue},
  tagstyle=\color{purple},
  markfirstintag=true}
\KOMAoptions{DIV=24}
\pagestyle{empty}

\maketitle

\thispagestyle{empty}

\begin{center}
\begin{tabular}{ccc}
<xsl:text disable-output-escaping="yes"><![CDATA[\textbf{Status} & \textbf{Type} & \textbf{Short Name} \\
]]></xsl:text>
<xsl:value-of select="/xep/header/status"/>
<xsl:text disable-output-escaping="yes"><![CDATA[ & ]]></xsl:text>
<xsl:value-of select="/xep/header/type"/>
<xsl:text disable-output-escaping="yes"><![CDATA[ & ]]></xsl:text>
<xsl:value-of select="/xep/header/shortname"/>
\end{tabular}
\end{center}

\begin{abstract}
<xsl:value-of select="/xep/header/abstract"/>
\end{abstract}

\newpage

\fancyhead[L,L]{\includegraphics[totalheight=10pt]{xmpp.pdf} \slshape \leftmark}
\fancyfoot[C,C]{\thepage}
\KOMAoptions{DIV=10}

\section*{Legal}
<xsl:apply-templates select="/xep/header/legal" />
\newpage
\tableofcontents
\newpage
\pagestyle{fancy}
\setcounter{page}{1}
\end{document}
<xsl:apply-templates/>
</xsl:template>

<!-- for legal crap -->
<xsl:template match="copyright">
  \subsection*{Copyright}
  {\small <xsl:apply-templates/>}
</xsl:template>

<xsl:template match="permissions">
  \subsection*{Permissions}
  {\small <xsl:apply-templates/>}
</xsl:template>

<xsl:template match="warranty">
  \subsection*{Warranty}
  {\small <xsl:apply-templates/>}
</xsl:template>

<xsl:template match="liability">
  \subsection*{Liability}
  {\small <xsl:apply-templates/>}
</xsl:template>

<xsl:template match="conformance">
  \subsection*{Conformance}
  {\small <xsl:apply-templates/>}
</xsl:template>


<xsl:template match="header">
</xsl:template>


<!-- table -->
<xsl:template match='table'>
  \begin{center}
  \begin{longtabu}{<xsl:for-each select='tr[1]/th | tr[1]/td'><xsl:if test="position() = 1">l</xsl:if><xsl:if test='position() != last() and position() > 1'>X</xsl:if><xsl:if test='position() = last()'>X</xsl:if></xsl:for-each>}
  <xsl:for-each select='tr'>
    <xsl:for-each select='td | th'><xsl:if test='position() > 1'> &amp; </xsl:if><xsl:value-of select='.'/><xsl:if test='position() = last()'> \\</xsl:if></xsl:for-each>
    <xsl:if test="position() = 1">
      \hline
      \hline
      \endhead
    </xsl:if>
  </xsl:for-each>
  \end{longtabu}
  \end{center}
</xsl:template>


<!-- link -->
<xsl:template match="span">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="link">
  <xsl:variable name="isHTTP">
    <xsl:call-template name="str:string-match">
      <xsl:with-param name="text"><xsl:value-of select="text()"/></xsl:with-param>
      <xsl:with-param name="pattern">*http*</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="isInternal">
    <xsl:call-template name="str:string-match">
      <xsl:with-param name="text"><xsl:value-of select="@url"/></xsl:with-param>
      <xsl:with-param name="pattern">#*</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>
  <xsl:if test="$isInternal = 0">\href{<xsl:value-of select='@url'/>}{<xsl:if test="$isHTTP = 1">\url{<xsl:apply-templates/>}</xsl:if><xsl:if test="$isHTTP = 0"><xsl:apply-templates/></xsl:if>}</xsl:if>
  <xsl:if test="$isInternal = 1">\hyperref[<xsl:value-of select='@url'/>]{<xsl:apply-templates/>}</xsl:if>
</xsl:template>

<!-- note -->
<xsl:template match="note">\footnote{<xsl:apply-templates/>}</xsl:template>

<!-- em -->
<xsl:template match="em">
  \emph{<xsl:apply-templates/>}
</xsl:template>

<!-- strong -->
<xsl:template match="strong">
  \textbf{<xsl:apply-templates/>}
</xsl:template>

<!-- sub -->
<xsl:template match="sub">
  \[\textsuperscript{<xsl:apply-templates/>}\]
  <math><cmd name="textsuperscript"><parm><xsl:apply-templates/></parm></cmd></math>
</xsl:template>

<!-- span[@class='super'] -->
<xsl:template match="span[@class='super']">
  <math><spec cat="sup"/><spec cat="bg"/><xsl:apply-templates/><spec cat="eg"/></math>
</xsl:template>


<!-- p -->
<xsl:template match="p">
<xsl:apply-templates/><xsl:text>\\
</xsl:text>
</xsl:template>

<!-- li -->
<xsl:template match="li">
  \item <xsl:apply-templates/>
</xsl:template>

<!-- ul -->
<xsl:template match="ul">
  \begin{itemize}
  <xsl:apply-templates/>
  \end{itemize}
</xsl:template>

<!-- ol -->
<xsl:template match="ol">
\begin{enumerate}
  <xsl:apply-templates/>
\end{enumerate}
</xsl:template>

<!-- dl -->
<xsl:template match="dl">
\begin{description}
  <xsl:apply-templates/>
\end{description}
</xsl:template>

<!-- di -->
<xsl:template match="di">
\item[<xsl:value-of select="./dt" />] <xsl:value-of select="./dd" />
</xsl:template>

<!-- example -->
<xsl:template match="example">
  \begin{lstlisting}[caption={<xsl:value-of select="@caption"/>}]
  <xsl:apply-templates />
  \end{lstlisting}
</xsl:template>

<xsl:template match="br">
  <!--<cmd name="newline" gr="0"/>-->

</xsl:template>

<!-- code -->
<xsl:template match="code">
  <xsl:if test='@class = "inline"'>
    \path{<xsl:value-of select="."/>}
  </xsl:if>
  <xsl:if test='not(@class)'>
    \begin{lstlisting}
    <!-- TODO: Figure out how to not escape this? -->
    <xsl:value-of select="."/>
    \end{lstlisting}
  </xsl:if>
</xsl:template>

<!-- img -->
<xsl:template match="img">
\begin{figure}{H}
\centering
\adjustimage{max size={.9\textwidth}{.9\textheight}}{inlineimage-<xsl:value-of select="/xep/header/number" />-<xsl:value-of select="count(preceding::img)" />}
\end{figure}
</xsl:template>

<!-- section3 -->
<xsl:template match="section3">
\subsubsection{<xsl:text></xsl:text><xsl:value-of select="@topic"/>}
\label{<xsl:value-of select="@anchor" />}
<xsl:apply-templates />
</xsl:template>

<!-- section2 -->
<xsl:template match="section2">
\subsection{<xsl:text></xsl:text><xsl:value-of select="@topic"/>}
\label{<xsl:value-of select="@anchor" />}
<xsl:apply-templates />
</xsl:template>

<!-- section1 -->
<xsl:template match="section1">
\section{<xsl:text></xsl:text><xsl:value-of select="@topic"/>}
\label{<xsl:value-of select="@anchor" />}
<xsl:apply-templates />
</xsl:template>



</xsl:stylesheet>
