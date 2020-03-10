Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49739180988
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Mar 2020 21:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbgCJUrY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Mar 2020 16:47:24 -0400
Received: from sender11-of-f72.zoho.eu ([31.186.226.244]:17324 "EHLO
        sender11-of-f72.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726268AbgCJUrY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Mar 2020 16:47:24 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 16:47:24 EDT
Received: from [100.109.64.191] (163.114.130.4 [163.114.130.4]) by mx.zoho.eu
        with SMTPS id 1583872333505296.61674064941235; Tue, 10 Mar 2020 21:32:13 +0100 (CET)
Subject: Re: [PATCH v2 0/6] Split fsverity-utils into a shared library
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
References: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6486476e-2109-cbd5-07d0-4c310d2c9f06@trained-monkey.org>
Date:   Tue, 10 Mar 2020 16:32:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200228212814.105897-1-Jes.Sorensen@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2/28/20 4:28 PM, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Hi,
> 
> Here is a reworked version of the patches to split fsverity-utils into
> a shared library, based on the feedback for the original version. Note
> this doesn't yet address setting the soname, and doesn't have the
> client (rpm) changes yet, so there is more work to do.
> 
> Comments appreciated.

Hi,

Any thoughts on this patchset?

Thanks,
Jes


> Cheers,
> Jes
> 
> Jes Sorensen (6):
>   Build basic shared library framework
>   Change compute_file_measurement() to take a file descriptor as
>     argument
>   Move fsverity_descriptor definition to libfsverity.h
>   Move hash algorithm code to shared library
>   Create libfsverity_compute_digest() and adapt cmd_sign to use it
>   Introduce libfsverity_sign_digest()
> 
>  Makefile      |  18 +-
>  cmd_enable.c  |  11 +-
>  cmd_measure.c |   4 +-
>  cmd_sign.c    | 526 ++++----------------------------------------------
>  fsverity.c    |  15 ++
>  hash_algs.c   |  26 +--
>  hash_algs.h   |  27 ---
>  libfsverity.h |  99 ++++++++++
>  libverity.c   | 526 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  util.h        |   2 +
>  10 files changed, 707 insertions(+), 547 deletions(-)
>  create mode 100644 libfsverity.h
>  create mode 100644 libverity.c
> 

