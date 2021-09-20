Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E9234127E2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Sep 2021 23:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbhITVXI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Sep 2021 17:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhITVVI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Sep 2021 17:21:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4A1A61184;
        Mon, 20 Sep 2021 21:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632172781;
        bh=MplE7LBVAl9zXP9vwhf4BHK4PTdYkt2vg1hMEoTCasI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JBNyrDTQLj4Mp0YcyNUD7IQSnwgiKcpQ8BiGcJ8IKgyqIJI2PdeanBdr20NOQvysF
         2i4vnKOxJG9QFGBMzsuZWKkYjha/oq9d3K2jiPDIYjV5UousrDhxAYSUKCiM7td6sA
         4wXImuHuNi/E/M5jdfickkfnluSHoIgki3EviGpDB/g2ra3An1G7hoLEVdtR8Sq7et
         KJae94XALsa5XBKUvbkLbnYO/785n2BUgjUkRupQ+1uiCS/AYnA8OKDnC6uo+BO7fH
         uGOXDSqGZuQ94e6v1mTxFwF/OMHgyM5BHP6RHZwkaLxofnOS9ZwaQrw0878izgTLy9
         Ta6am1zb6/0HQ==
Date:   Mon, 20 Sep 2021 14:19:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils] 1.4: test suite does not build
Message-ID: <YUj667bPkKxM4L+z@gmail.com>
References: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
 <YUZGUIRpVjNpupSi@sol.localdomain>
 <SA1PR15MB48247A9238700C0A1B12CCB6DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR15MB48247A9238700C0A1B12CCB6DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 20, 2021 at 08:05:25PM +0000, Aleksander Adamowski wrote:
> On Saturday, September 18, 2021 1:04 PM, Eric Biggers wrote:
> > Aleksander, can you look into these?
> 
> These look like compiler warnings, why did they break the build?
> 
> The reason for the warnings is that the Engines API that we use with OpenSSL <=
> 1.1 has started to be deprecated with OpenSSL release 3.0.
> 
> The replacement that OpenSSL offers is called "Providers":
> https://www.openssl.org/docs/man3.0/man7/migration_guide.html#Engines-and-METHOD-APIs
> 
> Unfortunately, the Providers API is only available starting with version 3.0,
> the same version that deprecates Engines:
> 
> https://www.openssl.org/docs/manmaster/man3/OSSL_PROVIDER_load.html
> 
> So, our options here are:
> 
> 1. Tolerate deprecation warnings from the compiler until the OpenSSL version
> that provides the new replacement API is widespread enough to stop supporting
> OpenSSL versions <= 1.1 (I think this is the most reasonable approach, after
> all that's how deprecation mechanisms are meant to be used).
> 
> 2. Use a bunch of preprocessor conditional #ifdefs to support both OpenSSL
> pre-3.0 with Engines and post-3.0 with Providers. This would make code pretty
> messy IMHO, but should be doable. I can start working on a patch if we get
> consensus; however, my opinion is that we should withhold from that until
> OpenSSL 3 is the standard release on mainstream distros.
> 

Sorry, it looks like I misread Tomasz's email; the build break wasn't from those
warnings but rather from the test programs not being linked to libfsverity.
Tomasz, are you using the provided Makefile?  In the Makefile, the test programs
are linked correctly, so this isn't an issue.  How can I reproduce your issue?

Aleksander: there still shouldn't be any compiler warnings.  In my test script
(scripts/run-tests.sh) I actually use -Werror.  If there isn't a good way to
avoid these deprecation warnings (and I'd prefer not to have code that's
conditional on different OpenSSL versions), we can just add
-Wno-deprecated-declarations to the Makefile for now.

- Eric
