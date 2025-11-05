Return-Path: <linux-fscrypt+bounces-923-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7031C35FF4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 05 Nov 2025 15:14:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 235831A20E31
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Nov 2025 14:14:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D9632937C;
	Wed,  5 Nov 2025 14:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ARZkQjaX"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8876A320CD9;
	Wed,  5 Nov 2025 14:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762352039; cv=none; b=P8s7fjFi3g9tNiyaswFCsT9OXlrNw5+nIelQQYoP0o0c8WHFVqlOAs6pvIkHWKe7/N0jt9ue0jFO91/aiAcE1T8j1aV57btninUcklqrobMXsMSrL20Et6PmQS63M3NhuDUJvgdTilwJjnbfHvnVSrztfbcvgZsbl84Nnkg5IuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762352039; c=relaxed/simple;
	bh=mhXbtiEH6qAblJDcaGWY99bememKt2hAAILJX1XxmYg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iWGwbGPQ93V2g4pGvahLz8E8UDiIbNVCcTTh4SnUxbxVH0NLmP6TfQwobt8CafMJ0IQx9AFdWnRb/KILyoRU1BS6+6wksA2Lh1juSqNVDxNHyLiMyCH+uBOHioxYIAT2UValwFJHLXR7H7bwx1Sqt4oIpgShzcrWimUUdgJ5YEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ARZkQjaX; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762352038; x=1793888038;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mhXbtiEH6qAblJDcaGWY99bememKt2hAAILJX1XxmYg=;
  b=ARZkQjaXoGO0K7O7y6TFhuoFMkbvAKe8kSJuPgauAun9yPP3+seD5wLu
   JladvKjyhBTc9Vj36vhHFpwFfnNPf7eImG5RUd0exMiGjFct3nGhaq4PI
   YAHDpoBm62a3D/VMY55x+zO++cG92qP/sA1Ofwe6cYdOCg+8C67EiyfWI
   4dtJD0QrhA4QzkoLb8aPwMxUkQeau1hULDYJFzq75yYTyd58PhNDx0df5
   wYYkTlW0Qrbd+H4wg3iUQtSIJ9G43Ol0tCAeoUAvV7AJKRhmUVuDmmZZS
   C3bMZY1UGP9B52uFEOerzlEDPna5pR45S6vbvBmmR/Pvrfl8UfY4q5WRr
   g==;
X-CSE-ConnectionGUID: CMETo4bdREy4Z+UijqmUgw==
X-CSE-MsgGUID: jVXMSMTsS2ecX2rzjo9lpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="68303910"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="68303910"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 06:13:57 -0800
X-CSE-ConnectionGUID: 8B3OwV01QkO7mVC115Q7Xg==
X-CSE-MsgGUID: jJyAflNhTJaCLLWk+18wPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="186753396"
Received: from ldmartin-desk2.corp.intel.com (HELO ashevche-desk.local) ([10.124.221.135])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 06:13:53 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vGeGg-00000005nwh-2EoW;
	Wed, 05 Nov 2025 16:13:46 +0200
Date: Wed, 5 Nov 2025 16:13:45 +0200
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
Message-ID: <aQtbmWLqtFXvT8Bc@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251104090326.2040fa75@pumpkin>
 <aQnMCVYFNpdsd-mm@smile.fi.intel.com>
 <20251105094827.10e67b2d@pumpkin>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105094827.10e67b2d@pumpkin>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Wed, Nov 05, 2025 at 09:48:27AM +0000, David Laight wrote:
> On Tue, 4 Nov 2025 11:48:57 +0200
> Andy Shevchenko <andriy.shevchenko@intel.com> wrote:
> > On Tue, Nov 04, 2025 at 09:03:26AM +0000, David Laight wrote:
> > > On Mon, 3 Nov 2025 19:07:24 +0800
> > > Kuan-Wei Chiu <visitorckw@gmail.com> wrote:  
> > > > On Mon, Nov 03, 2025 at 11:24:35AM +0100, Andy Shevchenko wrote:  

...

> > > > Since I believe many people test and care about W=1 builds, I think we
> > > > need to find another way to avoid this warning? Perhaps we could
> > > > consider what you suggested:
> > > > 
> > > > #define BASE64_REV_INIT(val_plus, val_comma, val_minus, val_slash, val_under) { \
> > > > 	[ 0 ... '+'-1 ] = -1, \
> > > > 	[ '+' ] = val_plus, val_comma, val_minus, -1, val_slash, \
> > > > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > > > 	[ '9'+1 ... 'A'-1 ] = -1, \
> > > > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > > > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > > > 	[ 'Z'+1 ... '_'-1 ] = -1, \
> > > > 	[ '_' ] = val_under, \
> > > > 	[ '_'+1 ... 'a'-1 ] = -1, \
> > > > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > > > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > > 	[ 'z'+1 ... 255 ] = -1 \
> > > > }  
> > > 
> > > I've a slightly better version:
> > > 
> > > #define INIT_62_63(ch, ch_62, ch_63) \
> > > 	[ ch ] = ch == ch_62 ? 62 : ch == ch_63 ? 63 : -1
> > > 
> > > #define BASE64_REV_INIT(ch_62, ch_63) { \
> > > 	[ 0 ... '0' - 6 ] = -1, \
> > > 	INIT_62_63('+', ch_62, ch_63), \
> > > 	INIT_62_63(',', ch_62, ch_63), \
> > > 	INIT_62_63('-', ch_62, ch_63), \
> > > 	INIT_62_63('.', ch_62, ch_63), \
> > > 	INIT_62_63('/', ch_62, ch_63), \
> > > 	[ '0' ] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, \
> > > 	[ '9' + 1 ... 'A' - 1 ] = -1, \
> > > 	[ 'A' ] = 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, \
> > > 		  23, 24, 25, 26, 27, 28, 28, 30, 31, 32, 33, 34, 35, \
> > > 	[ 'Z' + 1 ... '_' - 1 ] = -1, \
> > > 	INIT_62_63('_', ch_62, ch_63), \
> > > 	[ '_' + 1 ... 'a' - 1 ] = -1, \
> > > 	[ 'a' ] = 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, \
> > > 		  49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, \
> > > 	[ 'z' + 1 ... 255 ] = -1 \
> > > }
> > > 
> > > that only requires that INIT_62_63() be used for all the characters
> > > that are used for 62 and 63 - it can be used for extra ones (eg '.').
> > > If some code wants to use different characters; the -1 need replacing
> > > with INIT_62_63() but nothing else has to be changed.
> > > 
> > > I used '0' - 6 (rather than '+' - 1 - or any other expression for 0x2a)
> > > to (possibly) make the table obviously correct without referring to the
> > > ascii code table.  
> > 
> > Still it's heavily depends on the values of '+,-./_' as an index that
> > makes it not so flexible.
> 
> How about this one?

Better than previous one(s) but quite cryptic to understand. Will need a
comment explaining the logic behind, if we go this way.

> #define INIT_1(v, ch_lo, ch_hi, off, ch_62, ch_63) \
> 	[ v ] = ((v) >= ch_lo && (v) <= ch_hi) ? (v) - ch_lo + off \
> 		: (v) == ch_62 ? 62 : (v) == ch_63 ? 63 : -1
> #define INIT_2(v, ...) INIT_1(v, __VA_ARGS__), INIT_1((v) + 1, __VA_ARGS__)
> #define INIT_4(v, ...) INIT_2(v, __VA_ARGS__), INIT_2((v) + 2, __VA_ARGS__)
> #define INIT_8(v, ...) INIT_4(v, __VA_ARGS__), INIT_4((v) + 4, __VA_ARGS__)
> #define INIT_16(v, ...) INIT_8(v, __VA_ARGS__), INIT_8((v) + 8, __VA_ARGS__)
> #define INIT_32(v, ...) INIT_16(v, __VA_ARGS__), INIT_16((v) + 16, __VA_ARGS__)
> 
> #define BASE64_REV_INIT(ch_62, ch_63) { \
> 	[ 0 ... 0x1f ] = -1, \
> 	INIT_32(0x20, '0', '9', 0, ch_62, ch_63), \
> 	INIT_32(0x40, 'A', 'Z', 10, ch_62, ch_63), \
> 	INIT_32(0x60, 'a', 'z', 26, ch_62, ch_63), \
> 	[ 0x80 ... 0xff ] = -1 }
> 
> which gets the pre-processor to do all the work.
> ch_62 and ch_63 can be any printable characters.
> 
> Note that the #define names are all in a .c file - so don't need any
> kind of namespace protection.

> They can also all be #undef after the initialiser.

Yes, that's too.

> > Moreover this table is basically a dup of the strings in the first array.
> > Which already makes an unnecessary duplication.
> 
> That is what the self tests are for.
> 
> > That's why I prefer to
> > see a script (one source of data) to generate the header or something like
> > this to have the tables and strings robust against typos.
> 
> We have to differ on that one.
> Especially in cases (like this) where generating that data is reasonably trivial.
> 
> > The above is simply an unreadable mess.

-- 
With Best Regards,
Andy Shevchenko



