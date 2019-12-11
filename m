Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B316E11A835
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Dec 2019 10:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbfLKJuW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Dec 2019 04:50:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:42696 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727493AbfLKJuW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Dec 2019 04:50:22 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 01:50:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,301,1571727600"; 
   d="scan'208";a="363545358"
Received: from unknown (HELO localhost) ([10.237.50.137])
  by orsmga004.jf.intel.com with ESMTP; 11 Dec 2019 01:50:19 -0800
Date:   Wed, 11 Dec 2019 11:50:19 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Eric Biggers <ebiggers@kernel.org>, dhowells@redhat.com
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] xfstests: test adding filesystem-level fscrypt
 key via key_id
Message-ID: <20191211095019.GA7077@linux.intel.com>
References: <20191119223130.228341-1-ebiggers@kernel.org>
 <20191127204536.GA12520@linux.intel.com>
 <20191127225759.GA303989@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127225759.GA303989@sol.localdomain>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Nov 27, 2019 at 02:57:59PM -0800, Eric Biggers wrote:
> You could manually do what the xfstest does, which is more or less the following
> (requires xfs_io patched with https://patchwork.kernel.org/patch/11252795/):

I postpone testing/reviewing this patch up until its depedencies are in
the mainline.

I'll add these to my tree as soon as we have addressed a critical bug
in tpm_tis:

1. KEYS: remove CONFIG_KEYS_COMPAT
2. KEYS: asymmetric: return ENOMEM if akcipher_request_alloc() fails

Just mentioning that I haven't forgotten them.

/Jarkko
