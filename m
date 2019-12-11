Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02F2311BAE7
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Dec 2019 19:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbfLKSA5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Dec 2019 13:00:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730578AbfLKSA5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Dec 2019 13:00:57 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 728762077B;
        Wed, 11 Dec 2019 18:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576087256;
        bh=OYqCTsfffjEeTA1VhFj34IS3OchqHY+SnmJUY7K0xxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=02GWWfo+p3gVtrYfL3NiWWEgFvl6DTK1nOcw+Q8WFc85GK2xXybQSrt5nY5/axsGA
         EKWeBrP+7lsNbqm40w2NNNLBQgPoL3jWwK0DhmzPdmCMlz1vr3Zq8219FnTfmFEO2f
         J4623+gW2xVwbHmOXmKWrh48pbJ1nZgXRCq3lA28=
Date:   Wed, 11 Dec 2019 10:00:55 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     dhowells@redhat.com, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org
Subject: Re: [RFC PATCH 0/3] xfstests: test adding filesystem-level fscrypt
 key via key_id
Message-ID: <20191211180054.GB82952@gmail.com>
References: <20191119223130.228341-1-ebiggers@kernel.org>
 <20191127204536.GA12520@linux.intel.com>
 <20191127225759.GA303989@sol.localdomain>
 <20191211095019.GA7077@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211095019.GA7077@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Jarkko,

On Wed, Dec 11, 2019 at 11:50:19AM +0200, Jarkko Sakkinen wrote:
> On Wed, Nov 27, 2019 at 02:57:59PM -0800, Eric Biggers wrote:
> > You could manually do what the xfstest does, which is more or less the following
> > (requires xfs_io patched with https://patchwork.kernel.org/patch/11252795/):
> 
> I postpone testing/reviewing this patch up until its depedencies are in
> the mainline.
> 
> I'll add these to my tree as soon as we have addressed a critical bug
> in tpm_tis:
> 
> 1. KEYS: remove CONFIG_KEYS_COMPAT
> 2. KEYS: asymmetric: return ENOMEM if akcipher_request_alloc() fails
> 
> Just mentioning that I haven't forgotten them.
> 

xfstests and xfsprogs are developed separately from the kernel, and their
maintainers don't apply patches that depend on non-mainlined features.  So
unless there are objections to the kernel patch [1], in a couple weeks I'll
apply it to the fscrypt tree for 5.6, and then once it's in mainline I'll resend
the patches for the test.  I've simply sent the test out early as an RFC, in
case it helps reviewing the kernel patch or in case there are early comments.

Again, while you're certainly welcome to manually test the kernel patch, it's
more important that we have test coverage of it in xfstests.

[1] https://lkml.kernel.org/linux-fscrypt/20191119222447.226853-1-ebiggers@kernel.org/

- Eric
