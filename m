Return-Path: <linux-fscrypt+bounces-910-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C7EBC2FDDD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 09:28:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20BC1426974
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 08:26:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62EE03128AC;
	Tue,  4 Nov 2025 08:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ExCd/zIL"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F66C3101A3;
	Tue,  4 Nov 2025 08:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762244511; cv=none; b=tJPxeL9D1yoynZChahAEQ+qXmvus/a7oxTLvJI04EQbj9n1JvbCavVcKiZB99G+5YCYG5c/K9g68nPZUTFpabLJ780ZUWuiMS9ByizcGwYaxSlJ3l877o578dG5TvDuYIq0l3F6OZcDX2kVtXQ3ff0+pMLjIky5Iw1XlrrMFql4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762244511; c=relaxed/simple;
	bh=dP/Hm1oMz6SLtDZykC/Igqm1vfSgO20yu/vJJ9qLRMo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X+c1BH4+TT94K/4wXV5qiJIMRF64V66hbJ5/CdF9grgxHQ+g8b24EjT71J0M7xichVQqX1ldrSaGE0crUcT6jzFz62b9KX2wVRyCrC/hxvfGF5+RvRZ6lm5wa0Wo24Y571MKpxL5DxLBQzns1QvcD+7N3WNuzD+aPersHNaCQDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ExCd/zIL; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762244510; x=1793780510;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dP/Hm1oMz6SLtDZykC/Igqm1vfSgO20yu/vJJ9qLRMo=;
  b=ExCd/zIL/j9sbxL8qKfWHa3W2pbV1nl7lWndaRyzW7rQ3CdNfGGLZaWo
   r8kuEVQRh4sIZf0fBBSJjnLusDLYKdI3zJf1OJb08Svejp988B11PUV/Y
   iq7FpvsZOyyyRvGL9X+lpnI32PV3YQ84hpzGS94T6JOC5TKMk162kJJZG
   oomlwh0wfBvspoNeaaeQTbI6DlbkP3gdiNCvsXAmBwsxtfWUR5Yhi2OHc
   O0TlbDDzgqAKz8fTIpiJU0jvA7YtZlSRtNNyycsAdxtW/Ryo4JFlTcdff
   IXWhHjc93UujwACvuyC67u16eksMYNQHJih7i05iYFWl+24qRrut3QuUs
   A==;
X-CSE-ConnectionGUID: LoBAsbr0SHmj29/BwamQug==
X-CSE-MsgGUID: zfwK4ItcSMWdcraP8KDAsg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64364202"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="64364202"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 00:21:49 -0800
X-CSE-ConnectionGUID: WovW5LIVSY26PgrjKgcFmQ==
X-CSE-MsgGUID: hY8UqPEpSLKpogQ7xIGJsQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186338170"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.146])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 00:21:44 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vGCIO-00000005P6i-3Hb3;
	Tue, 04 Nov 2025 10:21:40 +0200
Date: Tue, 4 Nov 2025 10:21:40 +0200
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
Message-ID: <aQm3lHgM-M7ZRdVT@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251103132213.5feb4586@pumpkin>
 <aQi_JHjSi46uUcjB@smile.fi.intel.com>
 <aQjxjlJvLnx_zRx8@smile.fi.intel.com>
 <20251103192908.1d716a7b@pumpkin>
 <aQkEbZrabOzPBClg@smile.fi.intel.com>
 <20251103223255.3de9f9d7@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103223255.3de9f9d7@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 03, 2025 at 10:32:55PM +0000, David Laight wrote:
> On Mon, 3 Nov 2025 21:37:17 +0200
> Andy Shevchenko <andriy.shevchenko@intel.com> wrote:
> > On Mon, Nov 03, 2025 at 07:29:08PM +0000, David Laight wrote:
> > > On Mon, 3 Nov 2025 20:16:46 +0200
> > > Andy Shevchenko <andriy.shevchenko@intel.com> wrote:  
> > > > On Mon, Nov 03, 2025 at 04:41:41PM +0200, Andy Shevchenko wrote:  
> > > > > On Mon, Nov 03, 2025 at 01:22:13PM +0000, David Laight wrote:    

...

> > > > > Pragma will be hated.  
> > > 
> > > They have been used in a few other places.
> > > and to disable more 'useful' warnings.  
> > 
> > You can go with pragma, but even though it just hides the potential issues.
> > Not my choice.
> 
> In this case you really want the version that has '[ 0 .. 255 ] = -1,',
> everything else is unreadable and difficult to easily verify.

No, if it's a generated via a helper script.

> > > > > I believe there is a better way to do what you want. Let me cook a PoC.    
> > > > 
> > > > I tried locally several approaches and the best I can come up with is the pre-generated
> > > > (via Python script) pieces of C code that we can copy'n'paste instead of that shortened
> > > > form. So basically having a full 256 tables in the code is my suggestion to fix the build
> > > > issue. Alternatively we can generate that at run-time (on the first run) in
> > > > the similar way how prime_numbers.c does. The downside of such an approach is loosing
> > > > the const specifier, which I consider kinda important.
> > > > 
> > > > Btw, in the future here might be also the side-channel attack concerns appear, which would
> > > > require to reconsider the whole algo to get it constant-time execution.  
> > > 
> > > The array lookup version is 'reasonably' time constant.  
> > 
> > The array doesn't fit the cacheline.
> 
> Ignoring all the error characters it is 2 (64 byte) cache lines (if aligned
> on a 32 byte boundary).
> They'll both be resident for any sane input, I doubt an attacker can determine
> when the second one is loaded.
> In any case you can load both at the start just to make sure.

> > > One option is to offset all the array entries by 1 and subtract 1 after reading the entry.  
> > 
> > Yes, I was thinking of it, but found a bit weird.
> > 
> > > That means that the 'error' characters have zero in the array (not -1).
> > > At least the compiler won't error that!
> > > The extra 'subtract 1' is probably just measurable.  
> > 
> > > But I'd consider raising a bug on gcc :-)  
> > 
> > And clang? :-)
> 
> clang is probably easier to get fixed.
> The warning can be disabled for 'old' compilers - only one build 'tool'
> needs to detect errors.
> 
> One solution is to disable the warnings in the compilers, but get sparse
> (which I think is easier to change?) to do a sane check that allows
> the entire array to default to non-zero while still checking for
> other errors.
> 
> > > One of the uses of ranged designated initialisers for arrays is to change the
> > > default value - as been done here.
> > > It shouldn't cause a warning.  
> > 
> > This is prone to mistakes when it's not the default rewrite. I fixed already
> > twice such an issue in drivers/hid in the past few months.
> 
> I was thinking that if the first initialiser is [ low ... high ] = value
> then it should be valid to change any value.
> I'm not sure what you fixed, clearly [ 4 ] = 5, [ 4 ] = 6, is an error,
> but it might be sane to allow any update of a 'range' initialiser.

You can check a Git history for that.

-- 
With Best Regards,
Andy Shevchenko



