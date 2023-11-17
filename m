Return-Path: <linux-fscrypt+bounces-5-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2BF7EEBF2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Nov 2023 06:24:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17E62281302
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Nov 2023 05:24:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18C9DD273;
	Fri, 17 Nov 2023 05:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ATxyc/Di"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22EDD266;
	Fri, 17 Nov 2023 05:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3119AC433C8;
	Fri, 17 Nov 2023 05:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700198672;
	bh=otj+kKHBEQFfwTQUWipbjkRUInhszzJFCznCNIx193U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATxyc/DiM7VHfiLYTA23c9NFxUjE/ye5SZWOACsFqwqLDoJfCwyMf6txGbV0btsIc
	 Ltm/frn2KzuykZVEoHi67LzTIcBMieWLcwIVhQhwyCd1irla21ej95bzhOJZFoodpP
	 0+ZYE9k39OCD7kgA89asiIzkd9laHyynXbZ68k3DHt3r1iBCZO1Cif/XB7kdfHncHX
	 3K3H967cvNF1eXZdWnYlQNRoMqBgz96C2LfOwbRhZ3VW0myEG8X5q67ldeAdMYG9Fm
	 do35gzwSW/PGN5JVAnDUiP3YhxnlOoyXB8oxQlI2z4STuMAyElDnS5idvTqB2TNwHN
	 PPh0Gv6+Dm9ig==
Date: Thu, 16 Nov 2023 21:24:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: linux-xfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [xfsprogs PATCH] xfs_io/encrypt: support specifying crypto data
 unit size
Message-ID: <20231117052430.GB972@sol.localdomain>
References: <20231013062639.141468-1-ebiggers@kernel.org>
 <KMvmogj9a91wwFViEyqlFQPlIuusUrW4mllNMHHZWBgZzBLAzrSJ2c93ZZyLh7bh4tkBI-JTjQZ6LJrGHubXcQ==@protonmail.internalid>
 <20231116035846.GA1583@sol.localdomain>
 <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <h7e7q6g7ti4mbre55ap6x5o6suzdiiyykxtn5pgfsf2w6y7esx@tg2qxsplx2zb>

On Thu, Nov 16, 2023 at 11:04:16AM +0100, Carlos Maiolino wrote:
> On Wed, Nov 15, 2023 at 07:58:46PM -0800, Eric Biggers wrote:
> > On Thu, Oct 12, 2023 at 11:26:39PM -0700, Eric Biggers wrote:
> > > From: Eric Biggers <ebiggers@google.com>
> > >
> > > Add an '-s' option to the 'set_encpolicy' command of xfs_io to allow
> > > exercising the log2_data_unit_size field that is being added to struct
> > > fscrypt_policy_v2 (kernel patch:
> > > https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).
> > >
> > > The xfs_io support is needed for xfstests
> > > (https://lore.kernel.org/fstests/20231013061403.138425-1-ebiggers@kernel.org),
> > > which currently relies on xfs_io to access the encryption ioctls.
> > >
> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > > ---
> > >  configure.ac          |  1 +
> > >  include/builddefs.in  |  4 +++
> > >  io/encrypt.c          | 72 ++++++++++++++++++++++++++++++++-----------
> > >  m4/package_libcdev.m4 | 21 +++++++++++++
> > >  man/man8/xfs_io.8     |  5 ++-
> > >  5 files changed, 84 insertions(+), 19 deletions(-)
> > 
> > Hi!  Any feedback on this patch?
> 
> I've got a limited bandwidth these days, I'll try to review this sometime
> around next week.
> 

Thanks Carlos.

BTW, this is really just for xfstests.  To be honest, it might be a good idea to
remove the encryption commands from xfs_io, and make the encryption tests just
use an xfstests helper program, potentially in combination with fscryptctl
(https://github.com/google/fscryptctl) which now contains most of this
functionality too.  Then the XFS folks would have less to worry about.  Maybe
xfs_io has a backwards compatibility guarantee that makes this impossible, but
if not then it may be worth thinking about if the XFS folks don't want to have
to keep reviewing patches to the encryption commands like this.  The xfs_io
commands were what Dave had requested when I added the first encryption tests
back in 2016, so I did it that way, but maybe preferences have changed.

Anyway, review and/or thoughts are appreciated.

- Eric

