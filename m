Return-Path: <linux-fscrypt+bounces-256-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EB717881983
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Mar 2024 23:37:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6224283AD4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Mar 2024 22:37:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EE9836B01;
	Wed, 20 Mar 2024 22:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKKdmOaD"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145542209F;
	Wed, 20 Mar 2024 22:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710974258; cv=none; b=smI27q62pi6wzsFqFGenI3QlaJuxtfWyeF14g7OVYvW+FMPTp3ZTuRg8C5XbFH76bnQHAcOPQaMHPwLJ+gSP3aOs5x7fHF3oPQ8g5Tgy/u0jYuR/7M2QnewmGFKthBMBla+2aVNb0RXY2OM2B0PV2Qpzswfjt6qLBWOCfspD8uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710974258; c=relaxed/simple;
	bh=w+QN99fwvWSY3V2zBhacw4ulWGhs5g3W4vq3L8RlKpM=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A9/8ovvx9qW5gPV/8BiYeOIKZ6RZhE0JZrmuB+iz95SJ3EqpMcEfPNOjXvndXFmPLOx1ddSJ/k+4HitlNg/oFPggy6uaz5VErZ0xuUinPZ9s7n0Ngpt7q6FHoW1C2b9+XsNVNo4TwNuQ4ZdSgpn9+02dAWv13q2VZ875AcaveVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKKdmOaD; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8847FC433F1;
	Wed, 20 Mar 2024 22:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710974257;
	bh=w+QN99fwvWSY3V2zBhacw4ulWGhs5g3W4vq3L8RlKpM=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=NKKdmOaD18byQHhskxFA04Zz14nEsrmTYXVWqbCl/k5/mlvroJfirPryKjaexsyFu
	 81tIEyf5FKRpyKE5uzxsCzRmUSEYdmb2Z3t8wdKqbJOrWqoB8VTKPxgt41dB7PlDL9
	 3kqZdI6zXnM7ZNgJtqSHQpNMYxQmO675clBRkexnlXNMXO7PSZaXQ+lHTZyDNyrMYp
	 FSdD8B5yGtnOYro5yz+dwG1oP1zMTAHdNTVGdH8cZ4GVWJHxpfGtjkfXhGisg3I1bu
	 PRM70coRtj9N0dqlHTC58TN0XA7n2bUCqzbMZIU0pHRk+Gpf6YFPqNlJlDTZf9akph
	 CP2pyQzktrrZg==
Date: Wed, 20 Mar 2024 15:37:36 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: 1066832@bugs.debian.org, 1066832-submitter@bugs.debian.org,
	linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev
Subject: Re: Debian #1066832: [fsverity-utils] hard Build-Depends on
 unportable package pandoc
Message-ID: <20240320223736.GA2310@sol.localdomain>
References: <Pine.BSM.4.64L.2403140237160.10945@herc.mirbsd.org>
 <Pine.BSM.4.64L.2403140311320.10945@herc.mirbsd.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.BSM.4.64L.2403140311320.10945@herc.mirbsd.org>

[Added the correct mailing list, fsverity@lists.linux.dev]

On Thu, Mar 14, 2024 at 03:20:07AM +0000, Thorsten Glaser wrote:
> Dixi quod…
> 
> >Please split the package so that the part that requires pandoc is
> >done in an arch:all build. Normally, pandoc is needed only for
> >documentation, which is often easy enough to split off in a -doc
> >binary package, which can then move to B-D-Indep and be built on
> >amd64 or whatever hosts.
> 
> Looking at this in some detail, this is *only* ONE manual page.
> Splitting into a separate package for one file will not go over
> well with ftpmaster.
> 
> Dear upstream, please consider keeping the manpage in something
> else, like mdoc. I would be willing to convert the manpage to
> semantic, readable mdoc for you, even.
> 
> (fsverity-utils is a Build-Depends of rpm, some subpackages of
> which are necessary to build other software even in Debian.)
> 
> If upstream is not willing, we could:
> 
> • do this as local patch (effort updating it every time)
> 
> • hack a script that converts man/fsverity.1.md to mdoc;
>   this doesn’t need to be a full converter, it needs to
>   just be good enough to convert this one page (effort
>   one-time, but probably not much if at all when updating)
> 
> • as package maintainer, run the pandoc conversion script
>   and put the result into debian/fsverity.1 and install
>   from there and stop B-D’ing on pandoc (needs some, but
>   not much, manual effort on each update, and the package
>   maintainer to have a clean sid system on which to do that)
> 
> • install a dummy manpage (that maybe summarises the options
>   and points the reader to
>   https://manpages.debian.org/unstable/fsverity/fsverity.1.en.html
>   for the full page) on architectures without pandoc (needs
>   a bit of initial hacking, and to keep a whitelist of arches
>   with pandoc up-to-date)
> 
> bye,
> //mirabilos

I'm not sure how reasonable this request is (surely the rpm package should not
be depending on the fsverity manual page...), but to eliminate the reliance on
pandoc I've gone ahead and replaced the markdown file fsverity.1.md with a
native Linux man page fsverity.1.  So, it no longer needs any conversion before
installing it.

I did not choose mdoc, as I'm not familiar with it and it seems to be a BSD-ism.

- Eric

