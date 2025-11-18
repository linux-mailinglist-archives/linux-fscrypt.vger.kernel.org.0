Return-Path: <linux-fscrypt+bounces-984-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A111AC68DE0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Nov 2025 11:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 816DD4E1524
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Nov 2025 10:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2314343D8A;
	Tue, 18 Nov 2025 10:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DIOSVJm5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8319733CE83;
	Tue, 18 Nov 2025 10:38:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763462333; cv=none; b=gAu284uwYTphNnf79pO0k+Vv0gFNx7s9mYEtZjy3zlDtFqkk7ClC1/6PPtNIR60kGen55ccujxgj4fRdQqGW2coNww7jO8izlbrRByiNjg9hAWL3a+jKv3raI6oK9rBD9pQvXAazwSwvtbBS5AMWXTNkapDoysUkhz3qei6g0TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763462333; c=relaxed/simple;
	bh=iyd3lOPVc6CcM+zX3Th+vnH061kObST/SiMYoPr5O5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=obWLa8oGXedSZxygbXpqUD8yHVpJ8Y+tCffTm+icq41mIbdIps4Hiqo+4NOdJQ9xSzqXpj/1lcY3yUKpUVRAvTykc0IcLsLy9R9I2nPBe0EQ9iiufrBzafIDdDQfp+dMDvf7MQFbfgNAK0/E2Xslgh2Ga/EabMtcMQGZau/VDE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DIOSVJm5; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763462332; x=1794998332;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=iyd3lOPVc6CcM+zX3Th+vnH061kObST/SiMYoPr5O5o=;
  b=DIOSVJm50szAu0ZAjoA3UXyWxUIyAy2ugYSNKZPCt8q9EYnmuhggTWSR
   Nrn4SDN4C48HACFJKPww9u3SghW9yY7bB6fZ3vgMpTTHNBtuYuBBGb4II
   rf9rYyT/9oXS1EkK2q+qML39zIdcUHccChm7IYnSfFZioiPpcFuoTxjTD
   rn8z8DZekf1iVBjhKGDQNvEeCEQy+A+HMg3KB/jhN5vmVKePKCKe6ZERU
   2A5JGd1eGRXW4JILFCamZkX3+B2TKvk4CeouVAxEXBS6XwXG1wBMii5CW
   jIaeRnYWV9L+Gc2BxX3WcEwl0W3sbsSeYiMFtd/9TQVpCZwezfkoCeS7z
   g==;
X-CSE-ConnectionGUID: 8Xqg2OxjQxmCpYfjuR1R4g==
X-CSE-MsgGUID: cGGdcHVBRQqNm5qvqvaOKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11616"; a="69097123"
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="69097123"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2025 02:38:51 -0800
X-CSE-ConnectionGUID: 3+5y3f4oSPCBezs0UuP3sw==
X-CSE-MsgGUID: T0VmNn06S/m1gpEJLK3+pA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,314,1754982000"; 
   d="scan'208";a="214114335"
Received: from black.igk.intel.com ([10.91.253.5])
  by fmviesa002.fm.intel.com with ESMTP; 18 Nov 2025 02:38:47 -0800
Received: by black.igk.intel.com (Postfix, from userid 1003)
	id 3C33D96; Tue, 18 Nov 2025 11:38:46 +0100 (CET)
Date: Tue, 18 Nov 2025 11:38:46 +0100
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>,
	David Laight <david.laight.linux@gmail.com>, axboe@kernel.dk,
	ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
	kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
	sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com,
	xiubli@redhat.com
Subject: Re: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-ID: <aRxMtmatG7wbqJKL@black.igk.intel.com>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
 <20251114060132.89279-1-409411716@gms.tku.edu.tw>
 <20251114091830.5325eed3@pumpkin>
 <aRmnYTHmfPi1lyix@wu-Pro-E500-G6-WS720T>
 <20251117094652.b04c6cf841d6426f70f23d22@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251117094652.b04c6cf841d6426f70f23d22@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo

On Mon, Nov 17, 2025 at 09:46:52AM -0800, Andrew Morton wrote:
> On Sun, 16 Nov 2025 18:28:49 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:
> 
> > > Reviewed-by: David Laight <david.laight.linux@gmail.com>
> > > 
> > > But see minor nit below.
> > 
> > Hi David,
> > 
> > Thanks for the review and for pointing this out.
> > 
> > Andrew, would it be possible for you to fold this small change 
> > (removing the redundant casts) directly when updating the patch?
> > If that’s not convenient, I can resend an updated version of the
> > series instead. 
> 
> Sure, I added this:

The file also needs to fix the kernel-doc

$ scripts/kernel-doc -none -v -Wall lib/base64.c
Warning: lib/base64.c:24 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Initialize the base64 reverse mapping for a single character
Warning: lib/base64.c:36 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Recursive macros to generate multiple Base64 reverse mapping table entries.
Info: lib/base64.c:67 Scanning doc for function base64_encode
Info: lib/base64.c:119 Scanning doc for function base64_decode


-- 
With Best Regards,
Andy Shevchenko



