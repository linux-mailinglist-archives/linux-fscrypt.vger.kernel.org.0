Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC5B42353E6
	for <lists+linux-fscrypt@lfdr.de>; Sat,  1 Aug 2020 19:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbgHAR5a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 1 Aug 2020 13:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51488 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgHAR5a (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 1 Aug 2020 13:57:30 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BEDB206E9;
        Sat,  1 Aug 2020 17:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596304650;
        bh=/fUm+4TT4fkLCanjAHQP9BmHYRtA2bPU194VicAjJqw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PtgrHgQTkPo9ekCYAqy0SV7osGvomwYdsXoTTTeptvBEYcKB18McXIdAshf6kro3h
         T95P/tbDPbQbotCexHHG5lbAmItPV0OUSI3qvDF6l+mfI6zTBBOlpu7II/81sI8OWn
         73WCoHuVJFRtg3YpEWpqafkF4RE3rarVL74NjAMU=
Date:   Sat, 1 Aug 2020 10:57:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jsorensen@fb.com>
Cc:     linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>,
        Chris Mason <clm@fb.com>, kernel-team@fb.com,
        Victor Hsieh <victorhsieh@google.com>
Subject: Re: [fsverity-utils PATCH] Switch to MIT license
Message-ID: <20200801175728.GA14666@sol.localdomain>
References: <20200731191156.22602-1-ebiggers@kernel.org>
 <b55d6efd-0f2c-e63b-1074-e7ffedd56964@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55d6efd-0f2c-e63b-1074-e7ffedd56964@fb.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 31, 2020 at 04:37:33PM -0400, Jes Sorensen wrote:
> On 7/31/20 3:11 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > This allows libfsverity to be used by software with other common
> > licenses, e.g. LGPL, MIT, BSD, and Apache 2.0.  It also avoids the
> > incompatibility that some people perceive between OpenSSL and the GPL.
> > 
> > See discussion at
> > https://lkml.kernel.org/linux-fscrypt/20200211000037.189180-1-Jes.Sorensen@gmail.com/T/#u
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> 
> Acked-by: Jes Sorensen <jsorensen@fb.com>
> 
> 

Applied and pushed.  Thanks Chris and Jes!

- Eric
