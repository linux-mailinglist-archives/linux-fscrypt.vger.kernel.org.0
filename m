Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1450C2337F4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Jul 2020 19:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730204AbgG3Rwy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 30 Jul 2020 13:52:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728562AbgG3Rwy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 30 Jul 2020 13:52:54 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E21E42083B;
        Thu, 30 Jul 2020 17:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596131574;
        bh=n/2hSNa3DcXsbO8mzTQ5vvMptmmdIo0Yk1BhCdmlwnU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y7hg6N11L+xRx7A6X5Gx+efQoG2Loe0YcDjkjiV1g8an575VNSC6grdOAxSU3lsDX
         5xepD/3QnTCWDhY9TwUvt+yJ/q/hQ61DwdU9O1+tvvOtMDQ2f5N9uNgF6KtUnCHfNE
         /Rkfcid+nmS+vNFksoSRDaJiHvssKVwxRjuHZ4v0=
Date:   Thu, 30 Jul 2020 10:52:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     Jes Sorensen <jsorensen@fb.com>, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Message-ID: <20200730175252.GA1074@sol.localdomain>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
 <20200214203510.GA1985@gmail.com>
 <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Feb 19, 2020 at 06:49:07PM -0500, Jes Sorensen wrote:
> > We'd also need to follow shared library best practices like compiling with
> > -fvisibility=hidden and marking the API functions explicitly with
> > __attribute__((visibility("default"))), and setting the 'soname' like
> > -Wl,-soname=libfsverity.so.0.
> > 
> > Also, is the GPLv2+ license okay for the use case?
> 
> Personally I only care about linking it into rpm, which is GPL v2, so
> from my perspective, that is sufficient. I am also fine making it LGPL,
> but given it's your code I am stealing, I cannot make that call.
> 

Hi Jes, I'd like to revisit this, as I'm concerned about future use cases where
software under other licenses (e.g. LGPL, MIT, or Apache 2.0) might want to use
libfsverity -- especially if libfsverity grows more functionality.

Also, fsverity-utils links to OpenSSL, which some people (e.g. Debian) consider
to be incompatible with GPLv2.

We think the MIT license (https://opensource.org/licenses/MIT) would offer the
most flexibility.  Are you okay with changing the license of fsverity-utils to
MIT?  If so, I'll send a patch and you can give an Acked-by on it.

Thanks!

- Eric
