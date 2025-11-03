Return-Path: <linux-fscrypt+bounces-903-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 38C90C2C71E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 15:42:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B41F1894146
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 14:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6751D3128DF;
	Mon,  3 Nov 2025 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UVgRWj+t"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E8A2FE573;
	Mon,  3 Nov 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762180915; cv=none; b=akTiKFbrqyX1qESwfA8UGEIu0iss8oZYdVcjUrBxdD8tzJaTJmfW76/B1KN/01kTbrG47PSsJDEggH4qFoE20GtI/0wJw8FQMuCbbYpU1lpeAiSwLQZH33zRMB2c4x/4k++5P71yxLWtFLeDrcK0BkGyokJgvC9DLfZutblsVHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762180915; c=relaxed/simple;
	bh=jQ59v64epT75p54714TkgekaP2S42YjoI4BmxMoCpCM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cF9h4FnLwg3EyL3vtcXLdbMbicBaC4i3NNzSx+tJtAJDnDDljw71Vew4I5Z6Ac/Td2LBwoFanUjQdbvvPY4wbt5uwLPIAObQAQJ6pcqR3DCcds4Ue5BTs2dW7i9g0l5rEDkVhi3z15nVD7Hrmul19Jboqp046nDEOWeVlboUqgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UVgRWj+t; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762180914; x=1793716914;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jQ59v64epT75p54714TkgekaP2S42YjoI4BmxMoCpCM=;
  b=UVgRWj+tTfcIk/3x2KsHIx4iy/BmRi/OKK82BtULubPbfu28K9pfikNF
   DcvwSByhstmIw+XUCIi6AnRI7RiAFaPtwaBCkoqUB+zc20iGEMnXdSZTx
   yCISDoy0cr4kvl7ZwWcHx3VGPEDI89nC76+Vn+F4Cr59f63iK4thuU2bg
   EJsx6U+wezfgQ1m8kqGQ2Gu4QKfQAEwqW/Qfqzk4j8xFIDsiWKlpO9+7P
   Tf1bSuwbNV3+HXcCjxo0KmpSSPa+QsdVfEapGj5CYsTXz4hcPuS5poTuR
   uM5q0EDd7HR36gYLC9YZh1xHgZij8PXxmPMUpfuif3lMW6HQ5fWUqRCxc
   A==;
X-CSE-ConnectionGUID: 2hV1A2mFQ3a1CNu8Z9xnDA==
X-CSE-MsgGUID: +16ErR0NTvSv0LwoSYCu6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="63953110"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="63953110"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 06:41:52 -0800
X-CSE-ConnectionGUID: 0zAEEE0mQ46SUaPeP5Avdw==
X-CSE-MsgGUID: 1Pdepk/aQmO00uwm4FBN2Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="191208571"
Received: from smoehrl-linux.amr.corp.intel.com (HELO ashevche-desk.local) ([10.124.220.216])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 06:41:48 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vFvkb-00000005B1n-37cg;
	Mon, 03 Nov 2025 16:41:41 +0200
Date: Mon, 3 Nov 2025 16:41:40 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: David Laight <david.laight.linux@gmail.com>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	Andrew Morton <akpm@linux-foundation.org>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aQi_JHjSi46uUcjB@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251103132213.5feb4586@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103132213.5feb4586@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:
> On Mon, 3 Nov 2025 19:07:24 +0800
> Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
> > > On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:  
> > > > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

...

> > > > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > > > for this code.
> > > >   
> > > > > This improves throughput by ~43-52x.  
> > > > 
> > > > Well that isn't a thing we see every day.  
> > > 
> > > I agree with the judgement, the problem is that this broke drastically a build:
> > > 
> > > lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
> > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
> > >    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> > >       |                  ^
> > > lib/base64.c:35:17: note: previous initialization is here
> > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
> > >    25 |         [0 ... 255] = -1, \
> > >       |                       ^~
> > > ...
> > > fatal error: too many errors emitted, stopping now [-ferror-limit=]
> > > 20 errors generated.
> > >   
> > Since I didn't notice this build failure, I guess this happens during a
> > W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
> > to my checklist before sending patches in the future. I also got an
> > email from the kernel test robot with a duplicate initialization
> > warning from the sparse tool [1], pointing to the same code.
> > 
> > This implementation was based on David's previous suggestion [2] to
> > first default all entries to -1 and then set the values for the 64
> > character entries. This was to avoid expanding the large 256 * 3 table
> > and improve code readability.
> > 
> > Since I believe many people test and care about W=1 builds,
> 
> Last time I tried a W=1 build it failed horribly because of 'type-limits'.
> The kernel does that all the time - usually for its own error tests inside
> #define and inline functions.
> Certainly some of the changes I've seen to stop W=1 warnings are really
> a bad idea - but that is a bit of a digression.
> 
> Warnings can be temporarily disabled using #pragma.
> That might be the best thing to do here with this over-zealous warning.
> 
> This compiles on gcc and clang (even though the warnings have different names):
> #pragma GCC diagnostic push
> #pragma GCC diagnostic ignored "-Woverride-init"
> int x[16] = { [0 ... 15] = -1, [5] = 5};
> #pragma GCC diagnostic pop
> 
> > I think we need to find another way to avoid this warning?
> > Perhaps we could consider what you suggested:
> > 
> > #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> > 	[ 0 ... '+'-1 ] = -1, \
> > 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > 	[ '9'+1 ... 'A'-1 ] = -1, \
> > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > 	[ 'Z'+1 ... '_'-1 ] = -1, \
> > 	[ '_' ] = val_under, \
> > 	[ '_'+1 ... 'a'-1 ] = -1, \
> > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > 	[ 'z'+1 ... 255 ] = -1 \
> > }
> 
> I just checked, neither gcc nor clang allow empty ranges (eg [ 6 ... 5 ] = -1).
> Which means the coder has to know which characters are adjacent as well
> as getting the order right.
> Basically avoiding the warning sucks.
> 
> > Or should we just expand the 256 * 3 table as it was before?
> 
> That has much the same issue - IIRC it relies on three big sequential lists.
> 
> The #pragma may be best - but doesn't solve sparse (unless it processes
> them as well).

Pragma will be hated. I believe there is a better way to do what you want. Let
me cook a PoC.

> > [1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> > [2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/

-- 
With Best Regards,
Andy Shevchenko



