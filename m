Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681D8180A05
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Mar 2020 22:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCJVKE (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Mar 2020 17:10:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726271AbgCJVKE (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Mar 2020 17:10:04 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA048222C3;
        Tue, 10 Mar 2020 21:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583874604;
        bh=8/r2QkYGPl55U8WNvZ0hcMgaeY8rqmkP3u+3oWEveYM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zKoE5wSG0bH7No3rNDV8miaTbxRqlgs98aayI1OfOw1jNrzyQoWGcNxxVh2eYqljb
         1qPkXZkWOB//tWmDzg09trK1/gCfSMXgIA7+sRB3Ooao0EaOb57Bn5haVE+Du5XkQK
         2nccfQabdqofoLlaGl2Ve4nGPHZm09acpRlek2SA=
Date:   Tue, 10 Mar 2020 14:10:02 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH v2 0/6] Split fsverity-utils into a shared library
Message-ID: <20200310211002.GA46757@gmail.com>
References: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
 <6486476e-2109-cbd5-07d0-4c310d2c9f06@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6486476e-2109-cbd5-07d0-4c310d2c9f06@trained-monkey.org>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 10, 2020 at 04:32:12PM -0400, Jes Sorensen wrote:
> On 2/28/20 4:28 PM, Jes Sorensen wrote:
> > From: Jes Sorensen <jsorensen@fb.com>
> > 
> > Hi,
> > 
> > Here is a reworked version of the patches to split fsverity-utils into
> > a shared library, based on the feedback for the original version. Note
> > this doesn't yet address setting the soname, and doesn't have the
> > client (rpm) changes yet, so there is more work to do.
> > 
> > Comments appreciated.
> 
> Hi,
> 
> Any thoughts on this patchset?
> 
> Thanks,
> Jes
> 

It's been on my list of things to review but I've been pretty busy.  But a few
quick comments now:

The API needs documentation.  It doesn't have to be too formal; comments in
libfsverity.h would be fine.

Did you check that the fs-verity xfstests still pass?  They use fsverity-utils.
See: https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#tests

struct fsverity_descriptor and struct fsverity_hash_alg are still part of the
API.  But there doesn't seem to be any point in it.  Why aren't they internal to
libfsverity?

Can you make sure that the set of error codes for each API function is clearly
defined?

Can you make sure all API functions return an error if any reserved fields are
set?

Do you have a pointer to the corresponding RPM patches that will use this?

Also, it would be nice if you could also add some tests of the API to
fsverity-utils itself :-)

- Eric
