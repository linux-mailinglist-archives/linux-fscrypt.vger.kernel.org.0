Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C96F27321A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Sep 2020 20:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbgIUSmo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 21 Sep 2020 14:42:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727470AbgIUSmo (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 21 Sep 2020 14:42:44 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3B002084C;
        Mon, 21 Sep 2020 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600713764;
        bh=njm739HUAv+Vu8rLMMTyL9uw7vmOXqm25iDzxzDmNg8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ptc5eJBslvgL+xp0Wk+jIGRdxGpVMcfnklIR+0dp0c8fx3USgmeseMMW+MGh43AU6
         Nq0J4xdql7U4RWlfU4mJYUHJtPeMd9yj6eSfc+tXP1j+LBQXLxDsX35t6AZZvmHgzD
         9iOy419VA8rOaEwaGOeMZHFG5exj0VU1AlM6sscM=
Date:   Mon, 21 Sep 2020 11:42:42 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Satya Tangirala <satyat@google.com>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH v2] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200921184242.GA844@sol.localdomain>
References: <20200709184145.GA3855682@gmail.com>
 <20200709185832.2568081-1-satyat@google.com>
 <20200709191031.GB3855682@gmail.com>
 <20200901161726.GB669796@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901161726.GB669796@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 01, 2020 at 09:17:26AM -0700, Eric Biggers wrote:
> On Thu, Jul 09, 2020 at 12:10:31PM -0700, Eric Biggers wrote:
> > On Thu, Jul 09, 2020 at 06:58:32PM +0000, Satya Tangirala wrote:
> > > The encryption feature doesn't play well with quota, and generic/587
> > > tests quota functionality.
> > > 
> > > Signed-off-by: Satya Tangirala <satyat@google.com>
> > 
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> Ted, are you planning to apply this?

Ping.
