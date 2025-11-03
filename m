Return-Path: <linux-fscrypt+bounces-905-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C39FC2D9F3
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 19:17:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1A37D342C8A
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 18:17:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DB6A22333B;
	Mon,  3 Nov 2025 18:16:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OPmvLzTA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77C1922F5;
	Mon,  3 Nov 2025 18:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762193819; cv=none; b=DKKzGDaqRzjD0DwYbyuw8PCEU4oj6WuzcuLFGrHKC+OBjz5pgRbBZKKv+4t2T9eYrPqkALGcehfsoQB/UPaXgvkQadZl33j2nZHcCt3X57P6lDzHff8tvaJ7tTwQJ6Q42xpyU6eY6ijyY0nYtqW04FCzWtOY3YAYAOu80yPZET0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762193819; c=relaxed/simple;
	bh=LKpLRhBfQ3KPIeTBXo6bwcaDfNJovNBRA7NSpmlZzl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b8n6m6KJxVdsG/kV3GKF61C8md/Cst7Nv+cdu8OZBL59kNyOKOBWFq+35o2IVl7bRn5rltn1JDMgI4Lzb5xfIVbZbw+e/97bzuRfK885pbqFSJDC+SpCg5JTKwhSWubSaLuybz+vn5GI5W2aWeIS/YtDQz6gJHTvM4ppcMSCSkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OPmvLzTA; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762193818; x=1793729818;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=LKpLRhBfQ3KPIeTBXo6bwcaDfNJovNBRA7NSpmlZzl8=;
  b=OPmvLzTAdFyLhiBAnH/88t1dh67KDLkKsSgRCzaJt70KxtGVe21z2jYK
   xm45j6Cv7LqeK90B53UVWy+n8qDoz9Qw692qQnxplH/p9Z61bqY8i6F7+
   zxVfGNMcGoT3pgJykev4dMs5epQEWJ/bd9dlc0qlJqz9JgcbPEx7XcG3b
   oTztM702Eg58wDadhIzoLyBxK6gaSAbLUS4B2IebvW/pWh/P0EPn833Xm
   HtOBkqkAB5uSGq7a/6tjccf6OVIXSm+Cd00Cs/Yy0NEDInxFcMKJj4lnI
   EWapCjtucN3ip0Gb3G72ohUvVJBcyLTk6I2PeYoH1x67Zw4KUhg7r2/ko
   w==;
X-CSE-ConnectionGUID: ZeVX70pyRE2oKADc9324tQ==
X-CSE-MsgGUID: LBZjZzqiRiqTBUD26iWAFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89737907"
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="89737907"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:16:57 -0800
X-CSE-ConnectionGUID: zZSCZJj4Rb2K/tWgJOstrg==
X-CSE-MsgGUID: wo4zC5M2Sg6V8p9ci6pqPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,276,1754982000"; 
   d="scan'208";a="187657159"
Received: from smoehrl-linux.amr.corp.intel.com (HELO ashevche-desk.local) ([10.124.220.216])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 10:16:53 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vFz6l-00000005EWJ-1Dv3;
	Mon, 03 Nov 2025 20:16:47 +0200
Date: Mon, 3 Nov 2025 20:16:46 +0200
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
Message-ID: <aQjxjlJvLnx_zRx8@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251103132213.5feb4586@pumpkin>
 <aQi_JHjSi46uUcjB@smile.fi.intel.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQi_JHjSi46uUcjB@smile.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 03, 2025 at 04:41:41PM +0200, Andy Shevchenko wrote:
> On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:
> > On Mon, 3 Nov 2025 19:07:24 +0800
> > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:
> > > > On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:  
> > > > > On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

...

> > > > > Looks like wonderful work, thanks.  And it's good to gain a selftest
> > > > > for this code.
> > > > >   
> > > > > > This improves throughput by ~43-52x.  
> > > > > 
> > > > > Well that isn't a thing we see every day.  
> > > > 
> > > > I agree with the judgement, the problem is that this broke drastically a build:
> > > > 
> > > > lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
> > > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
> > > >    26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
> > > >       |                  ^
> > > > lib/base64.c:35:17: note: previous initialization is here
> > > >    35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
> > > >       |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
> > > > lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
> > > >    25 |         [0 ... 255] = -1, \
> > > >       |                       ^~
> > > > ...
> > > > fatal error: too many errors emitted, stopping now [-ferror-limit=]
> > > > 20 errors generated.
> > > >   
> > > Since I didn't notice this build failure, I guess this happens during a
> > > W=1 build? Sorry for that. Maybe I should add W=1 compilation testing
> > > to my checklist before sending patches in the future. I also got an
> > > email from the kernel test robot with a duplicate initialization
> > > warning from the sparse tool [1], pointing to the same code.
> > > 
> > > This implementation was based on David's previous suggestion [2] to
> > > first default all entries to -1 and then set the values for the 64
> > > character entries. This was to avoid expanding the large 256 * 3 table
> > > and improve code readability.
> > > 
> > > Since I believe many people test and care about W=1 builds,
> > 
> > Last time I tried a W=1 build it failed horribly because of 'type-limits'.
> > The kernel does that all the time - usually for its own error tests inside
> > #define and inline functions.
> > Certainly some of the changes I've seen to stop W=1 warnings are really
> > a bad idea - but that is a bit of a digression.
> > 
> > Warnings can be temporarily disabled using #pragma.
> > That might be the best thing to do here with this over-zealous warning.
> > 
> > This compiles on gcc and clang (even though the warnings have different names):
> > #pragma GCC diagnostic push
> > #pragma GCC diagnostic ignored "-Woverride-init"
> > int x[16] = { [0 ... 15] = -1, [5] = 5};
> > #pragma GCC diagnostic pop
> > 
> > > I think we need to find another way to avoid this warning?
> > > Perhaps we could consider what you suggested:
> > > 
> > > #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> > > 	[ 0 ... '+'-1 ] = -1, \
> > > 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> > > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > > 	[ '9'+1 ... 'A'-1 ] = -1, \
> > > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > > 	[ 'Z'+1 ... '_'-1 ] = -1, \
> > > 	[ '_' ] = val_under, \
> > > 	[ '_'+1 ... 'a'-1 ] = -1, \
> > > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > 	[ 'z'+1 ... 255 ] = -1 \
> > > }
> > 
> > I just checked, neither gcc nor clang allow empty ranges (eg [ 6 ... 5 ] = -1).
> > Which means the coder has to know which characters are adjacent as well
> > as getting the order right.
> > Basically avoiding the warning sucks.
> > 
> > > Or should we just expand the 256 * 3 table as it was before?
> > 
> > That has much the same issue - IIRC it relies on three big sequential lists.
> > 
> > The #pragma may be best - but doesn't solve sparse (unless it processes
> > them as well).
> 
> Pragma will be hated. I believe there is a better way to do what you want. Let
> me cook a PoC.

I tried locally several approaches and the best I can come up with is the pre-generated
(via Python script) pieces of C code that we can copy'n'paste instead of that shortened
form. So basically having a full 256 tables in the code is my suggestion to fix the build
issue. Alternatively we can generate that at run-time (on the first run) in
the similar way how prime_numbers.c does. The downside of such an approach is loosing
the const specifier, which I consider kinda important.

Btw, in the future here might be also the side-channel attack concerns appear, which would
require to reconsider the whole algo to get it constant-time execution.

> > > [1]: https://lore.kernel.org/oe-kbuild-all/202511021343.107utehN-lkp@intel.com/
> > > [2]: https://lore.kernel.org/lkml/20250928195736.71bec9ae@pumpkin/

-- 
With Best Regards,
Andy Shevchenko



