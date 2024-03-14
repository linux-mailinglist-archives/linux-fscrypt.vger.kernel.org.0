Return-Path: <linux-fscrypt+bounces-254-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 52BF487B6EB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Mar 2024 04:41:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 842101C20A31
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Mar 2024 03:41:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784524C9F;
	Thu, 14 Mar 2024 03:41:06 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from herc.mirbsd.org (bonn.mirbsd.org [217.91.129.195])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5C64C96
	for <linux-fscrypt@vger.kernel.org>; Thu, 14 Mar 2024 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.91.129.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710387666; cv=none; b=gaDk1awuMA5scbr8hICndWAK627UU/33XbKzcK+K/pJEgx2ihoIADNqwyEjMU0EkdWEdgy7iYUlsPjAMXDaS/QkDWUxPmDm265srPw8GNZ3Yrs9DlkoHRboO2kvlcJHoiMNAXBCtP7q7gnkeMX/wthIPYTtyPt/2IHUnMqb7phc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710387666; c=relaxed/simple;
	bh=ngKA+5K0v7Nls+4a4kmRPSd7taX463AvugR9w69aPbc=;
	h=Date:From:To:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=rux6d16ZkUdL17NNqrL5xBECQdTjhihErvW9DRDHYzc7iGEXt7hOomZJQgl0bXybgw0qKADB8OmxftExdyWjZ1QYXjk6/17V+5je9Vnnko0FaFwGnhwavWpFNJwDIcgqKdRJJsmgpz+y7iga45oM0koOtimWg2PRhxeO9tG/XSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; arc=none smtp.client-ip=217.91.129.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Received: from herc.mirbsd.org (tg@herc.mirbsd.org [192.168.0.82])
	by herc.mirbsd.org (8.14.9/8.14.5) with ESMTP id 42E3K8w8013904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
	Thu, 14 Mar 2024 03:20:14 GMT
Date: Thu, 14 Mar 2024 03:20:07 +0000 (UTC)
From: Thorsten Glaser <tg@debian.org>
X-X-Sender: tg@herc.mirbsd.org
Reply-To: 1066832@bugs.debian.org, 1066832-submitter@bugs.debian.org,
        linux-fscrypt@vger.kernel.org
To: 1066832@bugs.debian.org, linux-fscrypt@vger.kernel.org
Subject: Re: Debian #1066832: [fsverity-utils] hard Build-Depends on unportable
 package pandoc
In-Reply-To: <Pine.BSM.4.64L.2403140237160.10945@herc.mirbsd.org>
Message-ID: <Pine.BSM.4.64L.2403140311320.10945@herc.mirbsd.org>
References: <Pine.BSM.4.64L.2403140237160.10945@herc.mirbsd.org>
Content-Language: de-Zsym-DE-1901-u-em-text-rg-denw-tz-utc, en-Zsym-GB-u-cu-eur-em-text-fw-mon-hc-h23-ms-metric-mu-celsius-rg-denw-tz-utc-va-posix
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Dixi quod=E2=80=A6

>Please split the package so that the part that requires pandoc is
>done in an arch:all build. Normally, pandoc is needed only for
>documentation, which is often easy enough to split off in a -doc
>binary package, which can then move to B-D-Indep and be built on
>amd64 or whatever hosts.

Looking at this in some detail, this is *only* ONE manual page.
Splitting into a separate package for one file will not go over
well with ftpmaster.

Dear upstream, please consider keeping the manpage in something
else, like mdoc. I would be willing to convert the manpage to
semantic, readable mdoc for you, even.

(fsverity-utils is a Build-Depends of rpm, some subpackages of
which are necessary to build other software even in Debian.)

If upstream is not willing, we could:

=E2=80=A2 do this as local patch (effort updating it every time)

=E2=80=A2 hack a script that converts man/fsverity.1.md to mdoc;
  this doesn=E2=80=99t need to be a full converter, it needs to
  just be good enough to convert this one page (effort
  one-time, but probably not much if at all when updating)

=E2=80=A2 as package maintainer, run the pandoc conversion script
  and put the result into debian/fsverity.1 and install
  from there and stop B-D=E2=80=99ing on pandoc (needs some, but
  not much, manual effort on each update, and the package
  maintainer to have a clean sid system on which to do that)

=E2=80=A2 install a dummy manpage (that maybe summarises the options
  and points the reader to
  https://manpages.debian.org/unstable/fsverity/fsverity.1.en.html
  for the full page) on architectures without pandoc (needs
  a bit of initial hacking, and to keep a whitelist of arches
  with pandoc up-to-date)

bye,
//mirabilos
--=20
21:12=E2=8E=9C<Vutral> sogar bei opensolaris haben die von der community so
ziemlich jeden mist eingebaut =E2=94=82 man sollte unices nich so machen da=
s
desktopuser zuviel intresse kriegen =E2=94=82 das macht die code base kaput=
t
21:13=E2=8E=9C<Vutral:#MirBSD> linux war fr=C3=BCher auch mal besser :D

