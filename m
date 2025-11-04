Return-Path: <linux-fscrypt+bounces-911-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 59BC0C2FDB6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 09:27:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id F12AE34D79F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 08:26:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598762BEC4A;
	Tue,  4 Nov 2025 08:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UFQh8KZp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74E82248A8;
	Tue,  4 Nov 2025 08:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762244585; cv=none; b=JfacfZLPfH/kAwNGVZcmVcgplZ4qmnGI3bWluOtBs9BPwLZrLMwGuEBkM7QJOHu/phwgKtWwEiABivM2NA/cHrsIq8awG8x8oVursTcBiKpwXVeoQQCldKP1JZ6N4SCiSaBsQs7LxSbYa7Z9EhCWzBj8xIDP5jnm9wfybaFY7NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762244585; c=relaxed/simple;
	bh=NIF/ykNkFRIMVMhvlAFTIDIpUW32hk5+t/M9Wz6+bQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TXTnRF3GR5UIoQx++CgEe42bha35XiyJa6aSL2dVh7LmGQioaWNjwk2qNc8sfsEI92SzBKkKVhnghO+61csLZsx2jLEad9Whtl3fQd7dClLXQQSUs1v49V/fNEJc65ESicp6MOtQSuE22HjKb84Ti3t5I2Q2baiwWkQ9EQZtsN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UFQh8KZp; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762244583; x=1793780583;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=NIF/ykNkFRIMVMhvlAFTIDIpUW32hk5+t/M9Wz6+bQQ=;
  b=UFQh8KZptbRkFSxUA1/nnWPmZVN85sg3DCJt5lr9HIaoINqWERwIF4nt
   QjSYPL2OYdF5gNENMbb1d8klcXESvouMGibqSubCU2kieDZq/OW2YbBPv
   qhJWW6HYaEjNpv7pjaYQFUs6k/WuTS5Dn7QaIfenS8TyJBlkssqjSesvc
   ZMqpp14SfcjR/rj0zKy1OBdsWZleX1iJhqyKTf0Emp205NqfKPMjXyXZe
   gOC3rivRluRa1ppuQrNHnKvpawM/c3Yq2yZaoqCFSMTa81bvdYDUOCPPf
   xxN3Y5zY2iS2mdT5R+fCOQ4Y7SiaClTwY2rMLXP3Dmrazzsnt7+1d3ttX
   A==;
X-CSE-ConnectionGUID: QD9f5PhHT3K2m6OSEF370A==
X-CSE-MsgGUID: XVyf5Z1bQ3+O50aujCn47w==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="68170020"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="68170020"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 00:23:02 -0800
X-CSE-ConnectionGUID: vWdR5/+sQb+P/zt3KyKAbQ==
X-CSE-MsgGUID: GvGvYjO4RBmLtMYACn0KcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="191406230"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO ashevche-desk.local) ([10.245.245.146])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 00:22:58 -0800
Received: from andy by ashevche-desk.local with local (Exim 4.98.2)
	(envelope-from <andriy.shevchenko@intel.com>)
	id 1vGCJb-00000005P7y-1jmY;
	Tue, 04 Nov 2025 10:22:55 +0200
Date: Tue, 4 Nov 2025 10:22:55 +0200
From: Andy Shevchenko <andriy.shevchenko@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kuan-Wei Chiu <visitorckw@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Guan-Chun Wu <409411716@gms.tku.edu.tw>, ebiggers@kernel.org,
	tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
	idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
	sagi@grimberg.me, home7438072@gmail.com,
	linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-ID: <aQm333UwRAv0c4d3@smile.fi.intel.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
 <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
 <aQiC4zrtXobieAUm@black.igk.intel.com>
 <aQiM7OWWM0dXTT0J@google.com>
 <20251103172739.fd799d3df4edc014429babc5@linux-foundation.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103172739.fd799d3df4edc014429babc5@linux-foundation.org>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Mon, Nov 03, 2025 at 05:27:39PM -0800, Andrew Morton wrote:
> On Mon, 3 Nov 2025 19:07:24 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:
> 
> > Since I believe many people test and care about W=1 builds, I think we
> > need to find another way to avoid this warning? Perhaps we could
> > consider what you suggested:
> 
> I'll drop the v4 series from mm.git, thanks.

Thanks! I haven't got yet a newest Linux Next, but I think tomorrow it will be
okay for sure.

-- 
With Best Regards,
Andy Shevchenko



