Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641DDBE8E9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Sep 2019 01:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731431AbfIYX2M (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 Sep 2019 19:28:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731427AbfIYX2M (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 Sep 2019 19:28:12 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63EE3208C3;
        Wed, 25 Sep 2019 23:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569454091;
        bh=HgpJVoo1oDBsU4R190zGFEOuZgZWgudt8hbOnoLsuzE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0aMlxMnv4a/6hk8Mu5f5wNKf7jcJhhzTdIPgahGUi+TfQp5wJLPfmTGd/ATkO1dhf
         gGZcPmpo1us6dFX1uckmc++w99/DdJEbO/Tq8XuI/huJyS6Q8ifMR/7P9f+gpCBKE7
         KP4aYaTxOx5rxpsLMvNH1j2WvnEkcdiNkmrwABmI=
Date:   Wed, 25 Sep 2019 16:28:09 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] xfs_io/encrypt: extend 'get_encpolicy' to
 support v2 policies
Message-ID: <20190925232809.GC3163@gmail.com>
Mail-Followup-To: Eric Sandeen <sandeen@sandeen.net>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org
References: <20190812175635.34186-1-ebiggers@kernel.org>
 <20190812175635.34186-5-ebiggers@kernel.org>
 <93a8536c-191d-340e-2d18-2ef87d0dcd5d@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93a8536c-191d-340e-2d18-2ef87d0dcd5d@sandeen.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 25, 2019 at 12:23:25PM -0500, Eric Sandeen wrote:
> On 8/12/19 12:56 PM, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > get_encpolicy uses the FS_IOC_GET_ENCRYPTION_POLICY ioctl to retrieve
> > the file's encryption policy, then displays it.  But that only works for
> > v1 encryption policies.  A new ioctl, FS_IOC_GET_ENCRYPTION_POLICY_EX,
> > has been introduced which is more flexible and can retrieve both v1 and
> > v2 encryption policies.
> 
> ...
> 
> > +static void
> > +test_for_v2_policy_support(void)
> > +{
> > +	struct fscrypt_get_policy_ex_arg arg;
> > +
> > +	arg.policy_size = sizeof(arg.policy);
> > +
> > +	if (ioctl(file->fd, FS_IOC_GET_ENCRYPTION_POLICY_EX, &arg) == 0 ||
> > +	    errno == ENODATA /* file unencrypted */) {
> > +		printf("supported\n");
> > +		return;
> > +	}
> > +	if (errno == ENOTTY) {
> > +		printf("unsupported\n");
> > +		return;
> > +	}
> > +	fprintf(stderr,
> > +		"%s: unexpected error checking for FS_IOC_GET_ENCRYPTION_POLICY_EX support: %s\n",
> 
> Darrick also mentioned to me off-list that the io/encrypt.c code is chock full of
> strings that really need to be _("translatable")
> 

Sure, I can do that, though is this really something that people want?  These
commands are only intended for testing, and the xfsprogs translations don't seem
actively maintained (only 1 language was updated in the last 10 years?).

- Eric
