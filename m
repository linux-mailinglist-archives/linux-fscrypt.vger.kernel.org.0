Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAA13949D1
	for <lists+linux-fscrypt@lfdr.de>; Sat, 29 May 2021 03:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbhE2B11 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 28 May 2021 21:27:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhE2B11 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 28 May 2021 21:27:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93FA4613ED;
        Sat, 29 May 2021 01:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622251551;
        bh=QhUPoIc9aBsjRfJYG6b9uP9AXjnqcEjU5qgFOz3g6q8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uTY6Zk/TA3X+ZYG5LaL8LQiAmE1yX8s2XglUP30U2JTk74L3UDnnQtyqUuKh1TmlU
         hSItTlK3IPWKjydCqcmTWggZpOACy508U/R4jzfUSxO1Ujwp/jsg0Vgw00bFPhv9MV
         lKe3kSRLmE1AG/WSZMhvP7tVQt3uD4il4qBH+hcZVJB63ltdQsSzlNzvd/S/IaL6JP
         TftN+YPUGKcbe+a+j+4FBr3eObtNMTMis6L+NhV4XYiFKVxgcvledxXzoWdtNZPolo
         FobNk8r+YsD4ML09djNyNZjujjl4Vd747Jkq4bgZHnQ3xrLixgKuvPs2RbvgC0jO2l
         i3wPvwIA8mJBQ==
Date:   Fri, 28 May 2021 18:25:50 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jerry Chung <jchung@proofpoint.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: Is fscrypt encryption FIPS compliant?
Message-ID: <YLGYHtNESzN5F1hM@sol.localdomain>
References: <BL1PR12MB5334C36420D5A8669D7856BFA0239@BL1PR12MB5334.namprd12.prod.outlook.com>
 <YLA1eIEOi3yHWk4X@gmail.com>
 <BL1PR12MB53345FE179D9FA84F0231F3AA0229@BL1PR12MB5334.namprd12.prod.outlook.com>
 <BL1PR12MB5334640D3CB4D8124DD95594A0229@BL1PR12MB5334.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB5334640D3CB4D8124DD95594A0229@BL1PR12MB5334.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 28, 2021 at 04:26:56PM +0000, Jerry Chung wrote:
> Hi Eric,
> 
> Does fscrypt (kernel part and userspace part) implement any encryptions by
> itself? Or is it relying on the kernel crypto API?
> 
> Thanks,
> jerry

In the kernel part, currently the encryption algorithms are accessed through the
kernel crypto API and/or through blk-crypto (the kernel's interface to inline
encryption hardware).  The hash algorithms SHA-256 and SipHash are accessed
through their library interface.  The key derivation algorithm HKDF is
implemented in fs/crypto/ on top of HMAC-SHA512 from the kernel crypto API.

The userspace tool https://github.com/google/fscrypt (note, this isn't the only
userspace tool that can use the kernel part) uses cryptographic algorithms from
third-party Go packages, which get built into the resulting binary.  See the
source code for details.

Note that these are all implementation details, which may differ in past and
future versions of the software, both kernel and userspace.

- Eric
