Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28DC9415047
	for <lists+linux-fscrypt@lfdr.de>; Wed, 22 Sep 2021 20:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbhIVS7I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 22 Sep 2021 14:59:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237154AbhIVS7H (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 22 Sep 2021 14:59:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9292D6112F;
        Wed, 22 Sep 2021 18:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632337057;
        bh=Ug6zzOQ0V+KPOFAeYjgpY+jJbOUi39ScE2Vn7geSDRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PLpx/xNJFi8epju5gIG6uj63uDbQg/UixrZVVSAQXPRWTvjJTYaoy3i2QjQ2Uxp2X
         LVvzFwaHOdj3knQP3pEB0KP5Bhs5C+sEWEwHcoVziz/Y3zC+m3r9nWxqX6/HYQ+ZgX
         QgpzTf+J4vY8FIOhfh4C89mZNre2lORxFy24s4Wvqq2vjG+3gswlV2f0+BVpXH3a1q
         k6+MQAW4otsETkLr3xkcyItC0t5pEYvwrzvoHFdzxeq7D/zOnqd7fb5iLf3EL/Omoq
         fw8loAYDAVmC+taA+GYImUgxNhNA5f1eEfbapqsni+g1Ql6Z2NtqW2wgRkCLwnWct/
         2yRZADjyNoYUA==
Date:   Wed, 22 Sep 2021 11:57:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>,
        Tomasz =?utf-8?Q?K=C5=82oczko?= <kloczko.tomasz@gmail.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils] 1.4: test suite does not build
Message-ID: <YUt8oAgoapdvJREi@sol.localdomain>
References: <CABB28CwFNRhjgrT7NL6xqnasFQRJwhHZ4F0Xrd2XO-AZEyRBHQ@mail.gmail.com>
 <YUZGUIRpVjNpupSi@sol.localdomain>
 <SA1PR15MB48247A9238700C0A1B12CCB6DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YUj667bPkKxM4L+z@gmail.com>
 <SA1PR15MB4824F4BC9969A55AFD556182DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR15MB4824F4BC9969A55AFD556182DDA09@SA1PR15MB4824.namprd15.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 20, 2021 at 09:52:55PM +0000, Aleksander Adamowski wrote:
> On Mon, Sep 20, 2021 at 2:19 PM, Eric Biggers wrote:
> 
> > Aleksander: there still shouldn't be any compiler warnings.  In my test script
> > (scripts/run-tests.sh) I actually use -Werror.  If there isn't a good way to
> > avoid these deprecation warnings (and I'd prefer not to have code that's
> > conditional on different OpenSSL versions), we can just add
> > -Wno-deprecated-declarations to the Makefile for now.
> 
> I think -Wno-deprecated-declarations is the best option for now.
> 
> I took a few looks around and the community isn't ready for OpenSSL 3.0 just
> yet with PKCS#11 support.
> 
> The release happened just 2 weeks ago.
> 
> Projects like libp11 (https://github.com/OpenSC/libp11), the PKCS#11 engine
> implementation for OpenSSL, haven't yet caught up to that fact - there's no
> trace of discussion about migrating to the Providers API anywhere on their
> mailing lists or issue tracker.
> 
> The official OpenSSL release does not come with a PKCS#11 provider, and it only
> acknowledges a potential future existence of such in a single sentence in their
> design doc (https://www.openssl.org/docs/OpenSSL300Design.html):
> 
> "For example a PKCS#11 provider may opt out of caching because its algorithms
> may become available and unavailable over time."
> 
> Since this is a completely new, redesigned API, I expect it to take some time
> before alternatives to existing Engine-based implementations arise.

I've pushed out a change which adds -Wno-deprecated-declarations.

Tomasz, I'd still appreciate any details on what actually caused the test
programs to not build for you, as I can't reproduce it myself.

- Eric
