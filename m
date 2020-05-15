Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6091D5B28
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 May 2020 23:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbgEOVGG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 May 2020 17:06:06 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17155 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgEOVGF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 May 2020 17:06:05 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 May 2020 17:06:04 EDT
ARC-Seal: i=1; a=rsa-sha256; t=1589575853; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=KbsTO1QnXyP8AirHuZ24LqciMXjBICV8K0UBqFmWMt89qqPRpw4IRFDbcaLaFQs/Gkcx7VemFKXIbDQxqpxztV4TiwAMunpis8GMjJ1D7YGQBX41lVfp8JuslQKxJcCtFMx7P8z6NdB/80vKlpE52sgcp7XJ0EeWmNBfD3yodlI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1589575853; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=62g6JwVWEMzRWu3ZYkO8dV9Ce5Ih7CsFyMdKYPybmdU=; 
        b=iwA6hH5iqfReKpvEukZGydJX3Yqg/wLYvY3Rxv5wUX9JV8IaDfeb6AHIhjEaz2bPohUNz6fJte99XtSzsfE7ycBaPI+2i8qPgyt/I4j+e3FV/0mrxLT9Ywya0vL+JeIopw5DiS6xDPZxp6fl5YV6cC7UbtKN+RD6tHU2bh6gjnI=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [100.109.129.242] (163.114.130.1 [163.114.130.1]) by mx.zoho.eu
        with SMTPS id 1589575851412664.0614176836336; Fri, 15 May 2020 22:50:51 +0200 (CEST)
Subject: Re: [PATCH 0/3] fsverity-utils: introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6fd1ea1f-d6e6-c423-4a52-c987f172bb50@trained-monkey.org>
Date:   Fri, 15 May 2020 16:50:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200515041042.267966-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/15/20 12:10 AM, Eric Biggers wrote:
> From the 'fsverity' program, split out a library 'libfsverity'.
> Currently it supports computing file measurements ("digests"), and
> signing those file measurements for use with the fs-verity builtin
> signature verification feature.
> 
> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> I made a lot of improvements; see patch 2 for details.
> 
> Jes, can you let me know whether this works for you?  Especially take a
> close look at the API in libfsverity.h.

Hi Eric,

Thanks for looking at this. I have gone through this and managed to get
my RPM code to work with it. I will push the updated code to my rpm
github repo shortly. I have two fixes for the Makefile I will send to
you in a separate email.

One comment I have is that you changed the size of version and
hash_algorithm to 32 bit in struct libfsverity_merkle_tree_params, but
the kernel API only takes 8 bit values anyway. I had them at 16 bit to
handle the struct padding, but if anything it seems to make more sense
to make them 8 bit and pad the struct?

struct libfsverity_merkle_tree_params {
        uint32_t version;
        uint32_t hash_algorithm;

That said, not a big deal.

Cheers,
Jes
