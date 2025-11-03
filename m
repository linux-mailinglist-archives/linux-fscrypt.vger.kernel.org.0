Return-Path: <linux-fscrypt+bounces-900-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1DFC2B075
	for <lists+linux-fscrypt@lfdr.de>; Mon, 03 Nov 2025 11:24:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BE2734E2B08
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Nov 2025 10:24:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8652F9DB0;
	Mon,  3 Nov 2025 10:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KBWjo7l5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9288528E5;
	Mon,  3 Nov 2025 10:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762165482; cv=none; b=cf2Wf1aPkL/kOhFsGS+jpen3vBwVGx35XWqFwFeKJ+m4UzCt6jXgkr9hBVhePrCeLNPmbPbISInPFUCvitqbAiv/fG4Bwje2Ni9KAcsTzYmxgXG9S6t/N7hhBgR8PA3SRBVsVkymkmt3ZFaOEGZ5kGFyvbQ6WCbW/Ozb6faz+iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762165482; c=relaxed/simple;
	bh=mMwseOtfch0WkUGPSpFwAXRTLyTjgl9zM2KFRVdOVDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oJYlr/Dlo6mo/cdm5U8LzNVzz+zTrOAGPk9QwLloWZqXA4Qn0pXYhmtLZqmLxxhXhMu/5viZGo4RGuIQtk7ffDx7wFouix2I2FVkpCfwxD93qz6W8niD4QP5zVZtBXatclpzWLK/C94n9ejjh6pJyNLS1/yjL6M07f2fcHk0kQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KBWjo7l5; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762165480; x=1793701480;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mMwseOtfch0WkUGPSpFwAXRTLyTjgl9zM2KFRVdOVDg=;
  b=KBWjo7l5tOq2bHskEowWq4wuwyX7pS2j1THFAbaxGI12OdRjCzcz/DcI
   6rJqPRzrA4vK6lN67498wRbTmev19pYa/tf4GkDXGmHdJWhWUYivkybPM
   YAovTjqNfKe2uvejqDnKrB0d5MjRktz+gRu0CH7zoWGQYWfRNg5XSufEJ
   jz6MyYXIcxpc6Vtonbywy+1GKnLb+r0bGQrsxmMMLD6LiQvmwQc+hJW2G
   zwc5GWEV90FT6rAqFPLUWTkkMNh/8aUNg+kVy9qH/1p/LHjyMMuvUpudT
   Z3tvwY6lghLT84IVtHbZs532IOhAtdIYAQdI4btQAqjuAd3UbQDtpjgj5
   w==;
X-CSE-ConnectionGUID: 2RR3y4GZTKaZG0nhUuML1g==
X-CSE-MsgGUID: OhQvM02NRrywjtgGMAxysQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11601"; a="75684390"
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="75684390"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Nov 2025 02:24:40 -0800
X-CSE-ConnectionGUID: GSkOX9xmStqEMunUgyEZ7g==
X-CSE-MsgGUID: 0qHH5bPeSHCjgFcT4iPTOQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,275,1754982000"; 
   d="scan'208";a="186705439"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa006.fm.intel.com with ESMTP; 03 Nov 2025 02:24:36 -0800
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 8D05495; Mon, 03 Nov 2025 11:24:35 +0100 (CET)
Date: Mon, 3 Nov 2025 11:24:35 +0100
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, visitorckw@gmail.com, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aQiC4zrtXobieAUm@black.igk.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Fri, Oct 31, 2025 at 09:09:47PM -0700, Andrew Morton wrote:
> On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> > This series introduces a generic Base64 encoder/decoder to the kernel
> > library, eliminating duplicated implementations and delivering significant
> > performance improvements.
> > 
> > The Base64 API has been extended to support multiple variants (Standard,
> > URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
> > a variant parameter and an option to control padding. As part of this
> > series, users are migrated to the new interface while preserving their
> > specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
> > and NVMe is updated to BASE64_STD.
> > 
> > On the encoder side, the implementation processes input in 3-byte blocks,
> > mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
> > streaming and reduces loop overhead, achieving about a 2.7x speedup compared
> > to previous implementations.
> > 
> > On the decoder side, replace strchr() lookups with per-variant reverse tables
> > and process input in 4-character groups. Each group is mapped to numeric values
> > and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
> > rejecting invalid '=' usage and enforcing tail rules.
> 
> Looks like wonderful work, thanks.  And it's good to gain a selftest
> for this code.
> 
> > This improves throughput by ~43-52x.
> 
> Well that isn't a thing we see every day.

I agree with the judgement, the problem is that this broke drastically a build:

lib/base64.c:35:17: error: initializer overrides prior initialization of this subobject [-Werror,-Winitializer-overrides]
   35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
lib/base64.c:26:11: note: expanded from macro 'BASE64_REV_INIT'
   26 |         ['A'] =  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, \
      |                  ^
lib/base64.c:35:17: note: previous initialization is here
   35 |         [BASE64_STD] = BASE64_REV_INIT('+', '/'),
      |                        ^~~~~~~~~~~~~~~~~~~~~~~~~
lib/base64.c:25:16: note: expanded from macro 'BASE64_REV_INIT'
   25 |         [0 ... 255] = -1, \
      |                       ^~
...
fatal error: too many errors emitted, stopping now [-ferror-limit=]
20 errors generated.


> : Decode:
> :   64B   ~1530ns  ->  ~80ns    (~19.1x)
> :   1KB  ~27726ns  -> ~1239ns   (~22.4x)
> 
> 
> : Encode:
> :   64B   ~90ns   -> ~32ns   (~2.8x)
> :   1KB  ~1332ns  -> ~510ns  (~2.6x)
> : 
> : Decode:
> :   64B  ~1530ns  -> ~35ns   (~43.7x)
> :   1KB ~27726ns  -> ~530ns  (~52.3x)
> 
> 
> : This change also improves performance: encoding is about 2.7x faster and
> : decoding achieves 43-52x speedups compared to the previous implementation.
> 
> : This change also improves performance: encoding is about 2.7x faster and
> : decoding achieves 43-52x speedups compared to the previous local
> : implementation.
> 
> 
> Do any of these callers spend a sufficient amount of time in this
> encoder/decoder for the above improvements to be observable/useful?
> 
> 
> I'll add the series to mm.git's mm-nonmm-unstable branch to give it
> linux-next exposure.  I ask the NVMe, ceph and fscrypt teams to check
> the code and give it a test in the next few weeks, thanks.  
> 

-- 
With Best Regards,
Andy Shevchenko



