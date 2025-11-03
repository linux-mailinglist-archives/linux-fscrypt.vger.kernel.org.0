Return-Path: <linux-fscrypt+bounces-907-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id BCF47C2DEA5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 20:38:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 16FE94E03B4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 19:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE49C31E0FD;
	Mon,  3 Nov 2025 19:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OiCwAPOM"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F093164A0;
	Mon,  3 Nov 2025 19:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762198650; cv=none; b=KCc8P5cWi8LTncOlaoBgrqc9jd8Qt2T+JGCFbGtUwkz0d+7tGqC3w4k5Dma6iATU/3wy5a7ry7z7VB72+Kp6i+ywmj5Jg4HQiZPrwAv4GDucNHnx1GKKFQ/BfM4GIVbTRFhRZHH8ftMIDcr5O5PMhXuCdUtR0xldGailGbtTqSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762198650; c=relaxed/simple;
	bh=hgEOeQ/NAx7WrRk1gHE8VihYRMACDTSdXchi5b7f89Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pNYMFlCNFPhKYVcXyXCwXLDZvgZuqw9Lz4APo5owDnI31boldr5DEEzeyIgE2VCKT3Cr70tWH9M18lwIjm9AcYVLEuPxJvsuoxh25exsuP6eRZ1oNx2G6z/MX0cIOqwvzcTPM4XeH1xxyTxr1fJ/owDn16MB2pobIeRXl/8P/nI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OiCwAPOM; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762198649; x=1793734649;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hgEOeQ/NAx7WrRk1gHE8VihYRMACDTSdXchi5b7f89Q=;
  b=OiCwAPOMpzh/PIf2gcXm0dH7NHAO8X6KuaoGzwqI/5PHhvm49eKiLp/n
   qEWhILJM2Od1BMEqzgLc9nVnvXC7d20FvsKMYuyiwHspJMhAgflumSgTF
   rmq1c1R4qHpEH8Tdtq2uAkewxdmuVW4l/RFFuXqUzkRivqj6y8grXXACs
   jiOBS1g2HraLFxnauD94abSGlZIAYq3oBXfbx7BwLPwq2m9Bym78Z1bDn
   Sk5sOwUB1HUnmf8IrvxDPGeP69bKi0i1gDtrCpWLZx0DDqIkw3KxKNJbG
   LrgMuhS42Vt+H1PY0tcg2XblaFy3YKsfiP7pIqHvopQImFvHn0DJpVDAG
   w==;
X-CSE-ConnectionGUID: Y2Ak0VAcTfaxNzD+6Jz9Eg==
X-CSE-MsgGUID: UE76sayrSuWgxKAZVcnPFQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="51853517"
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="51853517"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 11:37:28 -0800
X-CSE-ConnectionGUID: IkgWZNzwSI6gCDkNlx30xg==
X-CSE-MsgGUID: A5QP/6+iRmurKpAVKqzaQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,277,1754982000"; 
   d="scan'208";a="187674793"
Received: from smoehrl-linux.amr.corp.intel.com (HELO ashevche-desk.local) ([10.124.220.216])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 11:37:25 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vG0Mg-00000005FeO-1lqu;
	Mon, 03 Nov 2025 21:37:18 +0200
Date: Mon, 3 Nov 2025 21:37:17 +0200
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
Message-ID: <aQkEbZrabOzPBClg@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251103132213.5feb4586@pumpkin>
 <aQi_JHjSi46uUcjB@smile.fi.intel.com>
 <aQjxjlJvLnx_zRx8@smile.fi.intel.com>
 <20251103192908.1d716a7b@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103192908.1d716a7b@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 03, 2025 at 07:29:08PM +0000, David Laight wrote:
> On Mon, 3 Nov 2025 20:16:46 +0200
> Andy Shevchenko <andriy.shevchenko@intel.com> wrote:
> > On Mon, Nov 03, 2025 at 04:41:41PM +0200, Andy Shevchenko wrote:
> > > On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:  

...

> > > Pragma will be hated.
> 
> They have been used in a few other places.
> and to disable more 'useful' warnings.

You can go with pragma, but even though it just hides the potential issues.
Not my choice.

> > > I believe there is a better way to do what you want. Let me cook a PoC.  
> > 
> > I tried locally several approaches and the best I can come up with is the pre-generated
> > (via Python script) pieces of C code that we can copy'n'paste instead of that shortened
> > form. So basically having a full 256 tables in the code is my suggestion to fix the build
> > issue. Alternatively we can generate that at run-time (on the first run) in
> > the similar way how prime_numbers.c does. The downside of such an approach is loosing
> > the const specifier, which I consider kinda important.
> > 
> > Btw, in the future here might be also the side-channel attack concerns appear, which would
> > require to reconsider the whole algo to get it constant-time execution.
> 
> The array lookup version is 'reasonably' time constant.

The array doesn't fit the cacheline.

> One option is to offset all the array entries by 1 and subtract 1 after reading the entry.

Yes, I was thinking of it, but found a bit weird.

> That means that the 'error' characters have zero in the array (not -1).
> At least the compiler won't error that!
> The extra 'subtract 1' is probably just measurable.

> But I'd consider raising a bug on gcc :-)

And clang? :-)

> One of the uses of ranged designated initialisers for arrays is to change the
> default value - as been done here.
> It shouldn't cause a warning.

This is prone to mistakes when it's not the default rewrite. I fixed already
twice such an issue in drivers/hid in the past few months.

-- 
With Best Regards,
Andy Shevchenko



