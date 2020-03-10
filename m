Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEB13180AEE
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Mar 2020 22:54:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726380AbgCJVyJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Mar 2020 17:54:09 -0400
Received: from sender11-of-f72.zoho.eu ([31.186.226.244]:17375 "EHLO
        sender11-of-f72.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgCJVyI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Mar 2020 17:54:08 -0400
Received: from [100.109.64.191] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1583877240236120.32714655497284; Tue, 10 Mar 2020 22:54:00 +0100 (CET)
Subject: Re: [PATCH v2 0/6] Split fsverity-utils into a shared library
To:     Eric Biggers <ebiggers@kernel.org>, Jes Sorensen <jsorensen@fb.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com
References: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
 <6486476e-2109-cbd5-07d0-4c310d2c9f06@trained-monkey.org>
 <20200310211002.GA46757@gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <406edf60-00d7-a4f8-6ae6-920317be2f60@trained-monkey.org>
Date:   Tue, 10 Mar 2020 17:53:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200310211002.GA46757@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 3/10/20 5:10 PM, Eric Biggers wrote:
> On Tue, Mar 10, 2020 at 04:32:12PM -0400, Jes Sorensen wrote:
>> On 2/28/20 4:28 PM, Jes Sorensen wrote:
>> Any thoughts on this patchset?
>>
>> Thanks,
>> Jes

Hi Eric,

Thanks for the quick response, a couple of comments:

> It's been on my list of things to review but I've been pretty busy.  But a few
> quick comments now:
> 
> The API needs documentation.  It doesn't have to be too formal; comments in
> libfsverity.h would be fine.

Absolutely, I wanted to at least roughly agree on the interfaces before
starting to do that.

> Did you check that the fs-verity xfstests still pass?  They use fsverity-utils.
> See: https://www.kernel.org/doc/html/latest/filesystems/fsverity.html#tests

I didn't, I will make sure to test this.

> struct fsverity_descriptor and struct fsverity_hash_alg are still part of the
> API.  But there doesn't seem to be any point in it.  Why aren't they internal to
> libfsverity?

I agree fsverity_descriptor should stay internal. I think struct
fsverity_hash_alg is better exposed. It provides useful information for
the caller, in particular the digest_size and allows for walking the
list of supported algorithms, which again makes it possible to implement
show_all_hash_algs(). If we kill it I would need to provide a
libfsverity_get_digest_size() call as a minimum.

> Can you make sure that the set of error codes for each API function is clearly
> defined?

I will go over this!

> Can you make sure all API functions return an error if any reserved fields are
> set?

Good point, I'll look into this.

> Do you have a pointer to the corresponding RPM patches that will use this?

That's my next job, will post something as soon as I have something useful.

> Also, it would be nice if you could also add some tests of the API to
> fsverity-utils itself :-)

Point taken :-)

Thanks,
Jes
