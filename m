Return-Path: <linux-fscrypt+bounces-913-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3882BC305B9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 10:54:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 639523A3B7A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 09:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62F3C2D46C0;
	Tue,  4 Nov 2025 09:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OdfVOXet"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A882609DC;
	Tue,  4 Nov 2025 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762249747; cv=none; b=N3rFTGIFj8hVszu+zOGKlzEdjqdaI6HY8GnOGlxRpE2lCQOgtR3FH3fcOj7c0E1hrf4kTC65+jXu5s3cPevAq+LOTX4J6Pu3X8rD71CNKIKHAv0Xcw+Q8y8E6RnZ5Ibbwc93bUwke47YKAIoVj6wlaClqxfLtgvSP23L8G3uZpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762249747; c=relaxed/simple;
	bh=xFNn8R9GSgOtgVVbPwExTDvjsAaEeew2m/fOM1y0PDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IFrtM7xTRZWvQx5hGYQ26XNL7YZOw1iyqeBRuoU8VIbi0Op7q8hMNrY34IJMuEW4M5I0kWQ7tNj9Mr1Q65D+NcIQJiejUTZ0XJeEfXXuPr2hhYP0jOPib6pghOvCydalXjCsEwbbZmhYYi64SWDLC6khSKq6Mxjkb0Bbn68CwsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OdfVOXet; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762249745; x=1793785745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xFNn8R9GSgOtgVVbPwExTDvjsAaEeew2m/fOM1y0PDQ=;
  b=OdfVOXetNSdKSHMOu/SCxS2cj1GEeS5HUWJEwRqyUpH7qYCxQModqnHx
   fc6PLWKLc60hLQuxKOnTQs0oM1fAEsxVyWweIMqHsNRJFEqpii2qRsNSC
   NOCjmN636UDGP4GadAiL7AYKUa8AlJr5tO3Fehw1uFkkMvH1LWpOcQs5B
   MDqcOPqCYGCTgl/JlJTTG2QKxFCBkY+R9guOUoMrLpsHRL6SoajIcT2Nz
   whx60rdcFI4yjram7iIWjyB6XsxTwi0tTyQzlZEYbyfvWbtntGzMMDcmD
   mxbO7DlT2w5KUBFOPPolh/jduVkIctkuzu1QmAvubt2dEdAbcj9/n4zgX
   g==;
X-CSE-ConnectionGUID: vKVZNEs+RhiLDcmkPktHVA==
X-CSE-MsgGUID: ZnYADOtkQT2DznskN3CNSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="64371184"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="64371184"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:49:04 -0800
X-CSE-ConnectionGUID: DTpau+4xQrGHRDFrDVtjaQ==
X-CSE-MsgGUID: bFPa4gb+TrCyIeBrHQLKGQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186804197"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.146])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:49:01 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vGDer-00000005QLT-1Zbv;
	Tue, 04 Nov 2025 11:48:57 +0200
Date: Tue, 4 Nov 2025 11:48:57 +0200
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
Message-ID: <aQnMCVYFNpdsd-mm@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251104090326.2040fa75@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104090326.2040fa75@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Nov 04, 2025 at 09:03:26AM +0000, David Laight wrote:
> On Mon, 3 Nov 2025 19:07:24 +0800
> Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:

...

> > Since I believe many people test and care about W=1 builds, I think we
> > need to find another way to avoid this warning? Perhaps we could
> > consider what you suggested:
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
> I've a slightly better version:
> 
> #define INIT_62_63(ch, ch_62, ch_63) \
> 	[ ch ] = ch == ch_62 ? 62 : ch == ch_63 ? 63 : -1
> 
> #define BASE64_REV_INIT(ch_62, ch_63) { \
> 	[ 0 ... '0' - 6 ] = -1, \
> 	INIT_62_63('+', ch_62, ch_63), \
> 	INIT_62_63(',', ch_62, ch_63), \
> 	INIT_62_63('-', ch_62, ch_63), \
> 	INIT_62_63('.', ch_62, ch_63), \
> 	INIT_62_63('/', ch_62, ch_63), \
> 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> 	[ '9' + 1 ... 'A' - 1 ] = -1, \
> 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> 	[ 'Z' + 1 ... '_' - 1 ] = -1, \
> 	INIT_62_63('_', ch_62, ch_63), \
> 	[ '_' + 1 ... 'a' - 1 ] = -1, \
> 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> 	[ 'z' + 1 ... 255 ] = -1 \
> }
> 
> that only requires that INIT_62_63() be used for all the characters
> that are used for 62 and 63 - it can be used for extra ones (eg '.').
> If some code wants to use different characters; the -1 need replacing
> with INIT_62_63() but nothing else has to be changed.
> 
> I used '0' - 6 (rather than '+' - 1 - or any other expression for 0x2a)
> to (possibly) make the table obviously correct without referring to the
> ascii code table.

Still it's heavily depends on the values of '+,-./_' as an index that
makes it not so flexible.

Moreover this table is basically a dup of the strings in the first array.
Which already makes an unnecessary duplication. That's why I prefer to
see a script (one source of data) to generate the header or something like
this to have the tables and strings robust against typos.

The above is simply an unreadable mess.

-- 
With Best Regards,
Andy Shevchenko



